import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/inbox_view_model.dart';

class InboxView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InboxViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inbox'),
          // centerTitle: true,
        ),
        body: Consumer<InboxViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.notifications.isEmpty) {
              return Container(
                margin: const EdgeInsets.all(40),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No messages yet',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
              itemCount: viewModel.notifications.length,
              itemBuilder: (context, index) {
                final notification = viewModel.notifications[index];
                return Card(
                  color: const Color.fromARGB(255, 251, 247, 244),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 244, 216, 174),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    child: ListTile(
                      title: Text(
                        notification.message,
                      ),
                      subtitle: Text(
                        notification.date.toLocal().toString().split('.')[0],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
