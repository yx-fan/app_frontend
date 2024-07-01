import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/trip_view_model.dart';
import 'trip_creation_view.dart';
import "../widgets/trip_card.dart";
import '../widgets/navigation.dart';
import '../services/navigation_service.dart';

class TripListView extends StatefulWidget {
  @override
  _TripListViewState createState() => _TripListViewState();
}

class _TripListViewState extends State<TripListView> {
  @override
  void initState() {
    super.initState();
    Provider.of<TripViewModel>(context, listen: false).fetchTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripCreationView(),
                ),
              );

              if (result == true) {
                // Refresh the trip list
                Provider.of<TripViewModel>(context, listen: false).fetchTrips();
              }
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
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripCreationView(),
                            ),
                          );

                          if (result == true) {
                            // Refresh the trip list
                            Provider.of<TripViewModel>(context, listen: false)
                                .fetchTrips();
                          }
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
                      trip: trip,
                      formattedDate: formattedDate,
                    );
                  },
                );
        },
      ),
    );
  }
}
