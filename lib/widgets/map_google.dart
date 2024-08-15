import 'package:app_frontend/widgets/map_expense_list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';
import '../services/expense_service.dart';
import '../viewmodels/map_view_model.dart';
import '../views/search_view.dart';

class MapGoogle extends StatefulWidget {
  final String? tripID;

  const MapGoogle({super.key, this.tripID});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  late Future<void> _initializeFuture;
  List<Expense> expenses = [];
  final ExpenseService expenseService = ExpenseService();
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default position (San Francisco)
    zoom: 10.0,
  );

  @override
  void initState() {
    super.initState();
    _initializeFuture = initialize();
  }

  LatLngBounds _getLatLngBounds(List<Expense> expenses) {
    double? minLat, maxLat, minLng, maxLng;

    for (var expense in expenses) {
      final lat = expense.latitude;
      final lng = expense.longitude;

      if (minLat == null || lat < minLat) minLat = lat;
      if (maxLat == null || lat > maxLat) maxLat = lat;
      if (minLng == null || lng < minLng) minLng = lng;
      if (maxLng == null || lng > maxLng) maxLng = lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  Future<void> initialize() async {
    try {
      expenses = widget.tripID == null
          ? await expenseService.fetchAllExpenses()
          : await expenseService.fetchExpenses(widget.tripID!);

      if (expenses.isNotEmpty) {
        // final firstExpense = expenses.first;
        // initialCameraPosition = CameraPosition(
        //   target: LatLng(firstExpense.latitude, firstExpense.longitude),
        //   zoom: 13.0,
        // );
        LatLngBounds bounds = _getLatLngBounds(expenses);
        initialCameraPosition = CameraPosition(
          target: LatLng(
            (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
            (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
          ),
          zoom: 13.0,
        );
      } else {
        await Geolocator.requestPermission()
            .then((value) {})
            .onError((e, StackTrace) {
          print('error$e');
        });
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        initialCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 13.0,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    return FutureBuilder<void>(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) async {
                  viewModel.setMapController(controller);
                  if (expenses.isNotEmpty) {
                    LatLngBounds bounds = _getLatLngBounds(expenses);
                    await controller.animateCamera(
                      CameraUpdate.newLatLngBounds(bounds, 50),
                    );
                  }
                },
                myLocationButtonEnabled: false,
                markers: expenses
                    .map(
                      (expense) => Marker(
                        markerId: MarkerId(expense.id),
                        position: LatLng(
                          expense.latitude,
                          expense.longitude,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange,
                        ),
                        infoWindow: InfoWindow(
                          title: expense.merchantName,
                          snippet: '\$${expense.amount}',
                        ),
                        onTap: () {
                          // viewModel.selectExpense(expense);
                        },
                      ),
                    )
                    .toSet(),
              ),
              if (widget.tripID != null) ...[
                // The Go back button
                Positioned(
                  top: 36,
                  left: 15,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_back),
                  ),
                )
              ],
              Positioned(
                // The Search Bar
                top: 40,
                left: widget.tripID == null ? 15 : 65,
                right: 15,
                child: GestureDetector(
                  onTap: () async {
                    final selectedAddress = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchView(mapViewModel: viewModel)),
                    );
                    if (selectedAddress != null) {
                      viewModel.updateSearchText(selectedAddress);
                      viewModel.searchAndNavigate(selectedAddress);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Consumer<MapViewModel>(
                            builder: (context, viewModel, child) => Text(
                              viewModel.searchController.text.isEmpty
                                  ? 'Search location'
                                  : viewModel.searchController.text,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                // The Locate myself button
                top: 90,
                right: 15,
                child: FloatingActionButton.small(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  onPressed: () {
                    viewModel.locateUser();
                  },
                  shape: const CircleBorder(),
                  child: const Icon(Icons.my_location),
                ),
              ),
              MapExpenseList(expenses: expenses),
            ],
          );
        }
      },
    );
  }
}
