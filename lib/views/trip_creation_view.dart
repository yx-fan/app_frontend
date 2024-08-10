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

class TripCreationView extends StatefulWidget {
  const TripCreationView({super.key});

  @override
  _TripCreationViewState createState() => _TripCreationViewState();
}

class _TripCreationViewState extends State<TripCreationView> {
  final _formKey = GlobalKey<FormState>();
  String _tripName = '';
  String _tripDescription = '';
  String _tripImageUrl = 'assets/trip_img1.jpg'; // Default image
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isSelectingDates = false;
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _tripDescriptionController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  Color _startDateColor = Colors.grey;
  Color _endDateColor = Colors.grey;
  bool _datesSelected = false;
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Trip'),
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
                          print("image url is $_tripImageUrl");
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
                        ThemeButtonSmall(
                          text: 'Create',
                          onPressed: () async {
                            // Use a Consumer to access InboxViewModel
                            await Provider.of<TripViewModel>(context,
                                    listen: false)
                                .createTrip(
                              _tripName,
                              _startDate,
                              _endDate,
                              _tripDescription,
                              _selectedCurrency,
                              _tripImageUrl,
                            )
                                .then((success) {
                              if (success) {
                                Provider.of<InboxViewModel>(context,
                                        listen: false)
                                    .fetchNotifications();
                                Navigator.pop(context,
                                    true); // Close the creation view and indicate success
                              }
                            });
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
