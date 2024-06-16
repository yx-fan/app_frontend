import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/trip_view_model.dart';
import 'trip_creation_view.dart';
import "../widgets/trip_card.dart";
import '../widgets/navigation.dart';

class TripListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripViewModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Trips'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripCreationView()));
                },
              ),
            ],
          ),
          body: Consumer<TripViewModel>(
            builder: (context, tripViewModel, child) {
              return tripViewModel.trips.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start creating your first trip bucket!',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TripCreationView()));
                            },
                            child: Text('Create'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tripViewModel.trips.length,
                      itemBuilder: (context, index) {
                        final trip = tripViewModel.trips[index];
                        final formattedDate =
                            DateFormat('MMMM d, yyyy').format(trip.startDate);
                        return TripCard(
                            trip: trip, formattedDate: formattedDate);
                      },
                    );
            },
          ),
          bottomNavigationBar: Navigation()),
    );
  }
}
