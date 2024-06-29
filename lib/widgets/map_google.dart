import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../viewmodels/map_view_model.dart';
import '../views/search_view.dart';

class MapGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    CameraPosition initialCameraPosition = const CameraPosition(
      target: LatLng(37.7749, -122.4194), // Default position (San Francisco)
      zoom: 12.0,
    );

    if (viewModel.expenses.isNotEmpty) {
      final firstReceipt = viewModel.expenses.first;
      initialCameraPosition = CameraPosition(
        target: LatLng(firstReceipt.latitude, firstReceipt.longitude),
        zoom: 12.0,
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            viewModel.setMapController(controller);
          },
          markers: viewModel.expenses
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
                      snippet: '\$${expense.amount}' //${expense.currency},
                      ),
                  onTap: () {
                    viewModel.selectExpense(expense);
                  },
                ),
              )
              .toSet(),
        ),
        Positioned(
          // The Search Bar
          top: 40,
          left: viewModel.tripID == 'all' ? 15 : 65,
          right: 15,
          child: GestureDetector(
            onTap: () async {
              final selectedAddress = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchView(mapViewModel: viewModel)),
              );
              if (selectedAddress != null) {
                viewModel.updateSearchText(selectedAddress);
                viewModel.searchAndNavigate(selectedAddress);
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
        if (viewModel.tripID != 'all') ...[
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
      ],
    );
  }
}
