import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/map_view_model.dart';
import '../widgets/map_google.dart';
import '../widgets/navigation.dart';
import '../services/navigation_service.dart';
import 'search_view.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          // Trip Map View needs 'Go Back" button
          // leading: Ink(
          //   decoration: const ShapeDecoration(
          //     color: Colors.white,
          //     shape: CircleBorder(),
          //   ),
          //   child: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () => Navigator.of(context).pop(),
          //   ),
          // ),
          title: Text('Map View'),
          actions: [
            Consumer<MapViewModel>(
              builder: (context, viewModel, child) => IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  final viewModel =
                      Provider.of<MapViewModel>(context, listen: false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchView(mapViewModel: viewModel)),
                  );
                },
              ),
            ),
          ],
        ),
        body: Builder(builder: (context) {
          Provider.of<MapViewModel>(context, listen: false)
              .setBottomSheetContext(context);
          return Stack(
            children: [
              MapGoogle(),
            ],
          );
        }),
        bottomNavigationBar: Consumer<MapViewModel>(
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
