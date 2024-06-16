import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/trip_viewmodel.dart';
import 'trip_creation_view.dart';
import "../widgets/trip_card.dart";

class TripListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TripCreationView()));
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
                                  builder: (context) => TripCreationView()));
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
                    return TripCard(trip: trip, formattedDate: formattedDate);
                  },
                );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: const Color.fromARGB(255, 3, 3, 3),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Star',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation based on the selected index
        },
      ),
    );
  }
}
