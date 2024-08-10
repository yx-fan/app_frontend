import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/trip_view_model.dart';
import '../viewmodels/star_view_model.dart';
import 'trip_creation_view.dart';
import "../widgets/trip_card.dart";

class TripListView extends StatefulWidget {
  const TripListView({super.key});

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
        title: const Text('Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TripCreationView(),
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
      body: Consumer2<TripViewModel, StarViewModel>(
        builder: (context, tripViewModel, starViewModel, child) {
          return tripViewModel.trips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Start creating your first trip bucket!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TripCreationView(),
                            ),
                          );

                          if (result == true) {
                            // Refresh the trip list
                            Provider.of<TripViewModel>(context, listen: false)
                                .fetchTrips();
                          }
                        },
                        child: const Text('Create'),
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

                    return Dismissible(
                      key: Key(trip
                          .tripId), // Ensure each Dismissible has a unique key
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // Perform the deletion and update both view models
                        final tripId = trip.tripId;
                        final tripName = trip.tripName;

                        setState(() {
                          tripViewModel.trips.removeAt(index);
                        });

                        tripViewModel.removeTrip(tripId);
                        starViewModel.cleanUpStarred(tripId);

                        // Show a snackbar for feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$tripName has been deleted'),
                          ),
                        );
                      },
                      background: Container(
                        color: Color.fromARGB(255, 245, 168, 45),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: TripCard(
                        trip: trip,
                        formattedDate: formattedDate,
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
