import 'dart:io';
import 'package:flutter/material.dart';
import '../services/receipt_service.dart';

class PreviewViewModel extends ChangeNotifier {
  final String imagePath;
  final String tripId;
  final ReceiptService _receiptService = ReceiptService();
  Map<String, dynamic>? parsedReceipt;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PreviewViewModel({required this.imagePath, required this.tripId});

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> uploadImage() async {
    setLoading(true);
    try {
      final response = await _receiptService.uploadReceiptImage(File(imagePath));
      parsedReceipt = response['data']['parsedReceipt'];
    } catch (e) {
      print('Failed to upload image: $e');
    } finally {
      setLoading(false);
    }
  }
}
