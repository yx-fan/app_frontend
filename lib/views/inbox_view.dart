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

              // Calculate whether the notification has expired
              final isExpired =
                  DateTime.now().difference(notification.date).inHours >= 24;

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
                              onPressed: () {
                                // Re-check if 24 hours have passed
                                final isExpiredNow = DateTime.now()
                                        .difference(notification.date)
                                        .inHours >=
                                    24;

                                if (isExpiredNow) {
                                  // Optionally, show a message to the user that the action has expired
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'This action has expired and can no longer be reverted.'),
                                    ),
                                  );
                                  return;
                                }

                                if (!notification.isReverted) {
                                  // Implement the revert logic using both view models
                                  tripViewModel.revertTrip(notification.note!);
                                  inboxViewModel
                                      .revertNotification(notification.note!);
                                  starViewModel
                                      .revertStarred(notification.note!);
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    isExpired || notification.isReverted
                                        ? Colors.grey
                                        : Colors.blue,
                              ),
                              child: Text(
                                notification.isReverted
                                    ? "Reverted"
                                    : isExpired
                                        ? "Expired"
                                        : "Revert",
                                style: TextStyle(
                                  color: isExpired || notification.isReverted
                                      ? Colors.grey
                                      : Color.fromARGB(255, 247, 161, 31),
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
