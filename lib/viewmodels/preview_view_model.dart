import 'dart:io';
import 'package:flutter/material.dart';

class PreviewViewModel extends ChangeNotifier {
  final String imagePath;

  PreviewViewModel({required this.imagePath});

  Future<void> uploadImage() async {
    // Implement the logic to upload the image to the backend and extract expense information
    // Example:
    // final response = await http.post(Uri.parse('your_api_endpoint'), body: {
    //   'image': base64Encode(File(imagePath).readAsBytesSync()),
    // });
    // Handle the response and notify listeners if needed
  }
}
