import 'package:app_frontend/widgets/theme_button_small.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../viewmodels/trip_view_model.dart';
import '../viewmodels/inbox_view_model.dart';
import '../viewmodels/currency_view_model.dart';
import '../views/image_select_view.dart';
import 'dart:io';
import '../models/trip_model.dart';

class EditTripView extends StatefulWidget {
  final Trip trip; // Trip to be edited

  const EditTripView({super.key, required this.trip});

  @override
  _EditTripViewState createState() => _EditTripViewState();
}

class _EditTripViewState extends State<EditTripView> {
  final _formKey = GlobalKey<FormState>();
  late String _tripName;
  late String _tripDescription;
  late String _tripImageUrl;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isSelectingDates = false;
  late TextEditingController _tripNameController;
  late TextEditingController _tripDescriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  Color _startDateColor = Colors.grey;
  Color _endDateColor = Colors.grey;
  bool _datesSelected = false;
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    // Initialize with existing trip details
    _tripName = widget.trip.tripName;
    _tripDescription = widget.trip.description ?? '';
    _tripImageUrl = widget.trip.imageUrl;
    _startDate = widget.trip.startDate;
    _endDate = widget.trip.endDate;

    // Fetch the currency value from the view model
    final currencyViewModel =
        Provider.of<CurrencyViewModel>(context, listen: false);
    _selectedCurrency =
        currencyViewModel.currencies[widget.trip.currencyId] ?? "USD";

    // Initialize controllers with existing data
    _tripNameController = TextEditingController(text: _tripName);
    _tripDescriptionController = TextEditingController(text: _tripDescription);
    _startDateController = TextEditingController(
        text: 'From: ${DateFormat('dd/MM/yy').format(_startDate)}');
    _endDateController = TextEditingController(
        text: 'To: ${DateFormat('dd/MM/yy').format(_endDate)}');
    _startDateColor = Colors.black;
    _endDateColor = Colors.black;
    _datesSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Trip'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final selectedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageSelectionView(
                            onImageSelected: (selectedImage) {
                              setState(() {
                                _tripImageUrl = selectedImage;
                              });
                            },
                          ),
                        ),
                      );
                      if (selectedImage != null) {
                        setState(() {
                          _tripImageUrl = selectedImage;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 100, // Make the CircleAvatar larger
                      backgroundImage: _tripImageUrl.startsWith('assets')
                          ? AssetImage(_tripImageUrl) as ImageProvider
                          : FileImage(File(_tripImageUrl)),
                      child: const Icon(
                        size: 40,
                        Icons.camera_alt,
                        color: Color.fromARGB(255, 241, 139, 5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  if (!_isSelectingDates) ...[
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: _tripNameController,
                        decoration: InputDecoration(
                          labelText: 'Enter trip name',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a trip name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _tripName = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: _tripDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Enter description (optional)',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSaved: (value) {
                          _tripDescription = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Consumer<CurrencyViewModel>(
                      builder: (context, currencyViewModel, child) {
                        return Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            child: DropdownSearch<String>(
                              items:
                                  currencyViewModel.currencies.values.toList(),
                              selectedItem: _selectedCurrency,
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Select Currency",
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                fit: FlexFit.loose,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCurrency = value!;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ThemeButtonSmall(
                        text: 'Next',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _isSelectingDates = true;
                              if (_datesSelected) {
                                _startDateController.text =
                                    'From: ${DateFormat('dd/MM/yy').format(_startDate)}';
                                _endDateController.text =
                                    'To: ${DateFormat('dd/MM/yy').format(_endDate)}';
                                _startDateColor = Colors.black;
                                _endDateColor = Colors.black;
                              } else {
                                _startDateController.text = 'From: dd/MM/yy';
                                _endDateController.text = 'To: dd/MM/yy';
                                _startDateColor = Colors.grey;
                                _endDateColor = Colors.grey;
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: () async {
                        final selectedDates = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDateRange:
                              DateTimeRange(start: _startDate, end: _endDate),
                        );
                        if (selectedDates != null) {
                          setState(() {
                            _startDate = selectedDates.start;
                            _endDate = selectedDates.end;
                            _startDateController.text =
                                'From: ${DateFormat('dd/MM/yy').format(_startDate)}';
                            _endDateController.text =
                                'To: ${DateFormat('dd/MM/yy').format(_endDate)}';
                            _startDateColor = Colors.black;
                            _endDateColor = Colors.black;
                            _datesSelected = true;
                          });
                        }
                      },
                      child: Column(
                        children: [
                          Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            child: TextFormField(
                              controller: _startDateController,
                              enabled: false,
                              style: TextStyle(color: _startDateColor),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            child: TextFormField(
                              controller: _endDateController,
                              enabled: false,
                              style: TextStyle(color: _endDateColor),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ThemeButtonSmall(
                          text: 'Back',
                          onPressed: () {
                            setState(() {
                              _isSelectingDates = false;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        // This is in EditTripView where the trip is being edited
                        ThemeButtonSmall(
                          text: 'Finish',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              try {
                                final success =
                                    await Provider.of<TripViewModel>(context,
                                            listen: false)
                                        .editTrip(
                                  widget.trip.tripId, // Pass the tripId
                                  _tripName,
                                  _startDate,
                                  _endDate,
                                  _tripDescription,
                                  _selectedCurrency,
                                  _tripImageUrl,
                                );

                                if (success) {
                                  print(
                                      'Edit successful, popping back to TripListView'); // Debug print
                                  Provider.of<InboxViewModel>(context,
                                          listen: false)
                                      .fetchNotifications();
                                  Navigator.pop(context,
                                      true); // This should pop back to TripListView
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to update trip. Please try again.'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                  ),
                                );
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
