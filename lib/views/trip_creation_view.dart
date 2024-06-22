// import 'package:app_frontend/widgets/theme_button_large.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../viewmodels/trip_view_model.dart';
// import '../models/trip_model.dart';
// import '../views/image_select_view.dart';

// class TripCreationView extends StatefulWidget {
//   @override
//   _TripCreationViewState createState() => _TripCreationViewState();
// }

// class _TripCreationViewState extends State<TripCreationView> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _tripNameController = TextEditingController();
//   final TextEditingController _tripDescriptionController =
//       TextEditingController();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();

//   String _tripImageUrl = 'assets/trip_img1.jpg'; // Default image
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(Duration(days: 7));
//   bool _isSelectingDates = false;
//   bool _startDateSelected = false;
//   bool _endDateSelected = false;

//   void _handleBackNavigation() {
//     if (_isSelectingDates) {
//       setState(() {
//         _isSelectingDates = false;
//       });
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   void _handleDateSelection() async {
//     final selectedDates = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
//     );
//     if (selectedDates != null) {
//       setState(() {
//         _startDate = selectedDates.start;
//         _endDate = selectedDates.end;
//         _startDateSelected = true;
//         _endDateSelected = true;
//         _startDateController.text =
//             'From: ${DateFormat('dd/MM/yy').format(_startDate)}';
//         _endDateController.text =
//             'To: ${DateFormat('dd/MM/yy').format(_endDate)}';
//       });
//     }
//   }

//   void _createTrip() {
//     final trip = Trip(
//       tripName: _tripNameController.text,
//       description: _tripDescriptionController.text,
//       imageUrl: _tripImageUrl,
//       startDate: _startDate,
//       endDate: _endDate,
//     );
//     Navigator.pop(context, trip);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvoked: (popDisposition) {
//         _handleBackNavigation();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Create a Trip'),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: _handleBackNavigation,
//           ),
//         ),
//         body: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ImageSelectionView(
//                               onImageSelected: (selectedImage) {
//                                 setState(() {
//                                   _tripImageUrl = selectedImage;
//                                 });
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                       child: CircleAvatar(
//                         radius: 100, // Make the CircleAvatar larger
//                         backgroundImage: AssetImage(_tripImageUrl),
//                         child: Icon(
//                           size: 40,
//                           Icons.camera_alt,
//                           color: Color.fromARGB(255, 241, 139, 5),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     if (!_isSelectingDates) ...[
//                       Material(
//                         elevation: 4,
//                         borderRadius: BorderRadius.circular(10),
//                         child: TextFormField(
//                           controller: _tripNameController,
//                           decoration: InputDecoration(
//                             labelText: 'Enter trip name',
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 10),
//                             filled: true,
//                             fillColor: Colors.white,
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a trip name';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Material(
//                         elevation: 4,
//                         borderRadius: BorderRadius.circular(10),
//                         child: TextFormField(
//                           controller: _tripDescriptionController,
//                           decoration: InputDecoration(
//                             labelText: 'Enter description (optional)',
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 10),
//                             filled: true,
//                             fillColor: Colors.white,
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       ThemeButtonLarge(
//                         text: 'Next',
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             _formKey.currentState!.save();
//                             setState(() {
//                               _isSelectingDates = true;
//                               _startDateController.text = 'From: dd/MM/yy';
//                               _endDateController.text = 'To: dd/MM/yy';
//                             });
//                           }
//                         },
//                       ),
//                     ] else ...[
//                       GestureDetector(
//                         onTap: _handleDateSelection,
//                         child: Column(
//                           children: [
//                             Material(
//                               elevation: 4,
//                               borderRadius: BorderRadius.circular(10),
//                               child: TextFormField(
//                                 controller: _startDateController,
//                                 enabled: false,
//                                 style: TextStyle(
//                                   color: _startDateSelected
//                                       ? Colors.black
//                                       : Colors.grey,
//                                 ),
//                                 decoration: InputDecoration(
//                                   labelText: 'From: dd/MM/yy',
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 10),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             Material(
//                               elevation: 4,
//                               borderRadius: BorderRadius.circular(10),
//                               child: TextFormField(
//                                 controller: _endDateController,
//                                 enabled: false,
//                                 style: TextStyle(
//                                   color: _endDateSelected
//                                       ? Colors.black
//                                       : Colors.grey,
//                                 ),
//                                 decoration: InputDecoration(
//                                   labelText: 'To: dd/MM/yy',
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 10),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       ThemeButtonLarge(
//                         text: 'Create Trip',
//                         onPressed: _createTrip,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
