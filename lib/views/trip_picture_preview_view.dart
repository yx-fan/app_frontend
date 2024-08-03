import 'dart:io';
import 'package:flutter/material.dart';

class TripPicturePreviewView extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRetake;

  const TripPicturePreviewView({super.key, 
    required this.imagePath,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(imagePath)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onRetake,
                child: const Text('Retake'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context,
                      imagePath); // Return the image path to the previous screen
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
