import 'dart:io';
import 'package:flutter/material.dart';
import '../services/receipt_service.dart';

class PreviewViewModel extends ChangeNotifier {
  final String imagePath;
  final ReceiptService _receiptService = ReceiptService();
  Map<String, dynamic>? parsedReceipt;

  PreviewViewModel({required this.imagePath});

  Future<void> uploadImage() async {
    try {
      final response = await _receiptService.uploadReceiptImage(File(imagePath));
      parsedReceipt = response['data']['parsedReceipt'];
      notifyListeners();
    } catch (e) {
      print('Failed to upload image: $e');
      notifyListeners();
    }
  }
}
