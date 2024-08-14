import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/preview_view_model.dart';
import 'create_expense_view.dart';

class PreviewView extends StatelessWidget {
  final String imagePath;
  final String tripId;

  const PreviewView({super.key, required this.imagePath, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreviewViewModel(imagePath: imagePath, tripId: tripId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Preview'),
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 0,
        ),
        body: Consumer<PreviewViewModel>(
          builder: (context, previewViewModel, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            onPressed: previewViewModel.isLoading ? null : () {
                              Navigator.pop(context);
                            },
                            child: const Text('Retake'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            onPressed: previewViewModel.isLoading ? null : () async {
                              await previewViewModel.uploadImage();
                              if (previewViewModel.parsedReceipt != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateExpenseView(
                                      imagePath: imagePath,
                                      receiptData: previewViewModel.parsedReceipt!,
                                      tripId: tripId,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to upload receipt')),
                                );
                              }
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (previewViewModel.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
