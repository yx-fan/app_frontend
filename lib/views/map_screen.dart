import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../viewmodels/map_view_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
 GoogleMapController? _mapController;

 @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                viewModel.currentLocation.latitude,
                viewModel.currentLocation.longitude,
              ),
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: viewModel.receipts
                .map(
                  (receipt) => Marker(
                    markerId: MarkerId(receipt.id),
                    position: LatLng(
                      receipt.location.latitude,
                      receipt.location.longitude,
                    ),
                    infoWindow: InfoWindow(
                      title: receipt.name,
                    ),
                    onTap: () {
                      viewModel.selectReceipt(receipt);
                    },
                  ),
                )
                .toSet(),
            onTap: (LatLng latLng) {
              viewModel.unselectReceipt();
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Handle back button press
                },
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.my_location),
                onPressed: () {
                  // Handle locate button press
                  // e.g., _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(viewModel.currentLocation.latitude, viewModel.currentLocation.longitude))));
                },
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 72,
            right: 72,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          if (viewModel.selectedReceipt != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.selectedReceipt!.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${viewModel.selectedReceipt!.date.year}/${viewModel.selectedReceipt!.date.month}/${viewModel.selectedReceipt!.date.day}',
                    ),
                    Text(
                      '${viewModel.selectedReceipt!.amount} ${viewModel.selectedReceipt!.currency}',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}