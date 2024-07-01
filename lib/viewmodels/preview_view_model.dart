import 'dart:io';
import 'package:flutter/material.dart';
import '../services/receipt_service.dart';

class PreviewViewModel extends ChangeNotifier {
  final String imagePath;
  final String tripId; // 添加 tripId
  final ReceiptService _receiptService = ReceiptService();
  Map<String, dynamic>? parsedReceipt;

  PreviewViewModel({required this.imagePath, required this.tripId}); // 更新构造函数

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
