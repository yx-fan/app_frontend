import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_frontend/viewmodels/map_view_model.dart';
import 'package:provider/provider.dart';

class MapGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.7749, -122.4194),
            zoom: 12.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            viewModel.setMapController(controller);
          },
          markers: viewModel.receipts
              .map(
                (receipt) => Marker(
                  markerId: MarkerId(receipt.id),
                  position: LatLng(
                    receipt.latitude,
                    receipt.longitude,
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange,
                  ),
                  infoWindow: InfoWindow(
                      title: receipt.name,
                      snippet: '\$${receipt.amount}' //${receipt.currency},
                      ),
                  onTap: () {
                    viewModel.selectReceipt(receipt);
                  },
                ),
              )
              .toSet(),
        ),
        Positioned(
          top: 120,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () {
                // Handle locate button press
                viewModel.locateUser();
              },
            ),
          ),
        ),
      ],
    );
  }
}
