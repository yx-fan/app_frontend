import 'package:app_frontend/widgets/map_google.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/map_view_model.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Ink(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: const TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            Provider.of<MapViewModel>(context, listen: false).setBottomSheetContext(context);
            return Stack(
              children: [
                MapGoogle(),
              ],
            );
          }
        ),
      ),
    );
  }
}
