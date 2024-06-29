import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/map_view_model.dart';
import '../widgets/map_google.dart';
import '../widgets/navigation.dart';
import '../services/navigation_service.dart';

class MapView extends StatelessWidget {
  final String tripID;

  MapView({required this.tripID});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(tripID: tripID),
      child: Scaffold(
        body: Builder(builder: (context) {
          Provider.of<MapViewModel>(context, listen: false)
              .setBottomSheetContext(context);
          return Stack(
            children: [
              MapGoogle(),
            ],
          );
        }),
        bottomNavigationBar: tripID != 'all'
            ? null
            : Consumer<MapViewModel>(
                builder: (context, mapViewModel, child) {
                  return Navigation(
                    currentIndex: mapViewModel.currentIndex,
                    onTap: (index) {
                      mapViewModel.changeTab(index);
                      NavigationService.navigateToPage(
                          context, index); // Use navigation service
                    },
                  );
                },
              ),
      ),
    );
  }
}
