import 'package:app_frontend/widgets/theme_button_large.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/trip_view_model.dart';
import '../views/image_select_view.dart';

class TripCreationView extends StatefulWidget {
  @override
  _TripCreationViewState createState() => _TripCreationViewState();
}

class _TripCreationViewState extends State<TripCreationView> {
  final _formKey = GlobalKey<FormState>();
  String _tripName = '';
  String _tripDescription = '';
  String _tripImageUrl = 'assets/trip_img1.jpg'; // Default image
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));
  bool _isSelectingDates = false;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  Color _startDateColor = Colors.grey;
  Color _endDateColor = Colors.grey;

  void _handleBackNavigation() {
    if (_isSelectingDates) {
      setState(() {
        _isSelectingDates = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_isSelectingDates) {
        if (_isSelectingDates) {
          setState(() {
            _isSelectingDates = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create a Trip'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _handleBackNavigation,
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
                      onTap: () {
                        Navigator.push(
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
                      },
                      child: CircleAvatar(
                        radius: 100, // Make the CircleAvatar larger
                        backgroundImage: AssetImage(_tripImageUrl),
                        child: Icon(
                          size: 40,
                          Icons.camera_alt,
                          color: Color.fromARGB(255, 241, 139, 5),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                    if (!_isSelectingDates) ...[
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter trip name',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
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
                      SizedBox(height: 30),
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter description (optional)',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
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
                      SizedBox(height: 30),
                      ThemeButtonLarge(
                        text: 'Next',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _isSelectingDates = true;
                              _startDateController.text = 'From: dd/MM/yy';
                              _endDateController.text = 'To: dd/MM/yy';
                              _startDateColor = Colors.grey;
                              _endDateColor = Colors.grey;
                            });
                          }
                        },
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
                                  contentPadding: EdgeInsets.symmetric(
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
                            SizedBox(height: 20),
                            Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(10),
                              child: TextFormField(
                                controller: _endDateController,
                                enabled: false,
                                style: TextStyle(color: _endDateColor),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
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
                      SizedBox(height: 20),
                      ThemeButtonLarge(
                        text: 'Create Trip',
                        onPressed: () async {
                          final success = await Provider.of<TripViewModel>(
                                  context,
                                  listen: false)
                              .createTrip(
                            _tripName,
                            _startDate,
                            _endDate,
                            _tripDescription,
                          );
                          if (success) {
                            Navigator.pop(context,
                                true); // Close the creation view and indicate success
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
