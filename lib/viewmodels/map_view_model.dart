import 'package:flutter/material.dart';
import '../models/map_model.dart';
import '../services/receipt_service.dart';

class MapViewModel extends ChangeNotifier {
  List<Receipt> receipts = [];
  Receipt? _selectedReceipt;

  final ReceiptService receiptService = ReceiptService();

  MapViewModel() {fetchReceipts();}

  Future<void> fetchReceipts() async {
    try {
      receipts = await receiptService.fetchReceipts();
      notifyListeners();
    } catch (e) {
      print('Failed to load receipts: $e');
    }
  }

  // void loadReceipts() {
  //   _receipts = [
  //     Receipt('1', 'Macy\'s', DateTime(2024, 1, 2), 100.0, 'USD',
  //         Location(37.7749, -122.4194)),
  //     Receipt('2', 'Car Rental', DateTime(2024, 1, 5), 200.0, 'USD',
  //         Location(37.7760, -122.4180)),
  //     Receipt('3', 'Marriott', DateTime(2024, 1, 10), 300.0, 'USD',
  //         Location(37.7770, -122.4170)),
  //     // Add more receipts with their respective locations
  //   ];
  //   notifyListeners();
  // }

  Receipt? get selectedReceipt => _selectedReceipt;

  void selectReceipt(Receipt receipt) {
    _selectedReceipt = receipt;
    notifyListeners();
  }

  void unselectReceipt() {
    _selectedReceipt = null;
    notifyListeners();
  }
}
