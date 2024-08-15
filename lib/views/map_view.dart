import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/map_view_model.dart';
import '../widgets/map_google.dart';

class MapView extends StatelessWidget {
  const MapView({super.key, this.tripID});

  final String? tripID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: Scaffold(
        body: tripID == null ? const MapGoogle() : MapGoogle(tripID: tripID),
      ),
    );
  }
}
