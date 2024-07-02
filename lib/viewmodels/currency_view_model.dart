import 'package:app_frontend/services/currency_service.dart';
import 'package:flutter/material.dart';

class CurrencyViewModel extends ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();
  Map<String, String> _currencies = {}; //currency key: currency code

  Map<String, String> get currencies => _currencies;

  CurrencyViewModel() {
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    try {
      _currencies = await _currencyService.fetchAllCurrencies();
      notifyListeners();
    } catch (e) {
      print("Failed to load trip details: $e");
    }
  }
}
