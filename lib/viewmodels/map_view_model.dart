import 'package:app_frontend/widgets/map_receipt.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/map_model.dart';
import '../services/receipt_service.dart';
import 'package:geolocator/geolocator.dart';
import '../services/google_places_service.dart';

class MapViewModel extends ChangeNotifier {
  List<Receipt> receipts = [];
  Receipt? _selectedReceipt;
  BuildContext? bottomSheetContext;
  LatLng? _currentLocation = LatLng(37.4223, -122.0848);
  GoogleMapController? _mapController;
  TextEditingController searchController = TextEditingController();

  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  final ReceiptService receiptService = ReceiptService();
  final GooglePlacesService placesService = GooglePlacesService();

  MapViewModel() {
    fetchReceipts();
  }

  Future<void> fetchReceipts() async {
    try {
      receipts = await receiptService.fetchReceipts();
      notifyListeners();
    } catch (e) {
      print('Failed to load receipts: $e');
    }
  }

  Receipt? get selectedReceipt => _selectedReceipt;

  void selectReceipt(Receipt receipt) {
    _selectedReceipt = receipt;
    notifyListeners();
    showBottomSheet();
  }

  void unselectReceipt() {
    _selectedReceipt = null;
    notifyListeners();
    hideBottomSheet();
  }

  void setBottomSheetContext(BuildContext context) {
    bottomSheetContext = context;
  }

  void showBottomSheet() {
    if (bottomSheetContext != null && selectedReceipt != null) {
      showModalBottomSheet(
        context: bottomSheetContext!,
        builder: (context) => MapReceipt(receipt: selectedReceipt!),
        isScrollControlled: true,
      );
    }
  }

  void hideBottomSheet() {
    if (bottomSheetContext != null) {
      Navigator.of(bottomSheetContext!).pop();
    }
  }

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  Future<void> locateUser() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((e, StackTrace) {
      print('error$e');
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currentLocation = LatLng(position.latitude, position.longitude);
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 13),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> searchAndNavigate(String query) async {
    try {
      final locations = await placesService.searchPlaces(query);
      if (locations.isNotEmpty) {
        final latLng = locations.first;
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: latLng, zoom: 13),
            ),
          );
        }
      }
    } catch (e) {
      print('Failed to search and navigate: $e');
    }
  }

  Future<List<String>> autocompleteSuggestions(String query) async {
    try {
      return await placesService.autocompletePlaces(query);
    } catch (e) {
      print('Failed to get autocomplete suggestions: $e');
      return [];
    }
  }

  void updateSearchText(String newText) {
    searchController.text = newText;
    notifyListeners();
  }

}
