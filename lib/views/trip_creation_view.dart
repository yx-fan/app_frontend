import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip_model.dart';
import '../viewmodels/trip_view_model.dart';

class TripCreationView extends StatefulWidget {
  @override
  _TripCreationViewState createState() => _TripCreationViewState();
}

class _TripCreationViewState extends State<TripCreationView> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  String _imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Trip Name'),
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trip name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              ListTile(
                title:
                    Text('Start Date: ${_startDate.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _startDate)
                    setState(() {
                      _startDate = picked;
                    });
                },
              ),
              ListTile(
                title: Text('End Date: ${_endDate.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: _startDate,
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _endDate)
                    setState(() {
                      _endDate = picked;
                    });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                onSaved: (value) {
                  _imageUrl = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Trip newTrip = Trip(
                      name: _name,
                      description: _description,
                      startDate: _startDate,
                      endDate: _endDate,
                      totalExpense: 0.0,
                      imageUrl: _imageUrl,
                    );
                    Provider.of<TripViewModel>(context, listen: false)
                        .addTrip(newTrip);
                    Navigator.pop(context);
                  }
                },
                child: Text('Create Trip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
