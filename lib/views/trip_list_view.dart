import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'trip_creation_view.dart';
import '../viewmodels/trip_view_model.dart';
import '../widgets/trip_card.dart';
import '../widgets/navigation.dart';
import '../models/trip_model.dart';

class TripListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => {},
            // onPressed: () async {
            //   final newTrip = await Navigator.push<Trip>(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => TripCreationView(),
            //     ),
            //   );
            //   if (newTrip != null) {
            //     Provider.of<TripViewModel>(context, listen: false)
            //         .addTrip(newTrip);
            //   }
            // },
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
                        onPressed: () => {},
                        // onPressed: () async {
                        //   final newTrip = await Navigator.push<Trip>(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => TripCreationView(),
                        //     ),
                        //   );
                        //   if (newTrip != null) {
                        //     Provider.of<TripViewModel>(context, listen: false)
                        //         .addTrip(newTrip);
                        //   }
                        // },
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
      bottomNavigationBar: Consumer<TripViewModel>(
        builder: (context, tripViewModel, child) {
          return Navigation(
            currentIndex: tripViewModel.currentIndex,
            onTap: (index) {
              tripViewModel.changeTab(index);
              // Implement navigation logic if necessary
            },
          );
        },
      ),
    );
  }
}
