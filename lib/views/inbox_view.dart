import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/inbox_view_model.dart';
import '../viewmodels/trip_view_model.dart';
import '../viewmodels/star_view_model.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: Consumer3<InboxViewModel, TripViewModel, StarViewModel>(
        builder:
            (context, inboxViewModel, tripViewModel, starViewModel, child) {
          if (inboxViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (inboxViewModel.notifications.isEmpty) {
            return Container(
              margin: const EdgeInsets.all(40),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'You’ll receive messages about your trip creation, edition, and deletion here.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: inboxViewModel.notifications.length,
            itemBuilder: (context, index) {
              final notification = inboxViewModel.notifications[index];

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.date.toLocal().toString().split('.')[0],
                        ),
                        const SizedBox(height: 4),
                        if (notification.note != null &&
                            notification.note!.isNotEmpty)
                          Text(
                            notification.note!,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        if (notification.title == "Trip Deleted")
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: notification.isReverted
                                  ? null
                                  : () {
                                      // Implement the revert logic using both view models
                                      tripViewModel
                                          .revertTrip(notification.note!);
                                      inboxViewModel.revertNotification(
                                          notification.note!);
                                      starViewModel
                                          .revertStarred(notification.note!);
                                    },
                              style: TextButton.styleFrom(
                                foregroundColor: notification.isReverted
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                              child: Text(
                                notification.isReverted ? "Reverted" : "Revert",
                                style: TextStyle(
                                  color: notification.isReverted
                                      ? Colors.grey
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
