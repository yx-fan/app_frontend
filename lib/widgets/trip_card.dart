import 'package:app_frontend/views/map_screen.dart';
import 'package:flutter/material.dart';
import '../views/trip_expense_view.dart';
import "../models/trip.dart";

class TripCard extends StatefulWidget {
  final Trip trip;
  final String formattedDate;

  TripCard({required this.trip, required this.formattedDate});

  @override
  _TripCardState createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 18),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.trip.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Starting Date: ${widget.formattedDate}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 16 / 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      15.0), // Adjust the radius as needed
                  child: Image(
                    image: ResizeImage(
                      AssetImage(widget.trip.imageUrl),
                      width: 933, // Adjust to the required width
                      height: 466, // Adjust to the required height
                    ),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement map functionality
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MapScreen(),
                            ),
                          );
                        },
                        child: Text('Map'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TripExpenseView(trip: widget.trip),
                            ),
                          );
                        },
                        child: Text('Details'),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt),
                          SizedBox(width: 6),
                          SizedBox(
                            width: 45,
                            child: Text('${widget.trip.expenses.length}'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isTapped = !_isTapped;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(_isTapped
                                ? Icons.visibility
                                : Icons.visibility_off),
                            SizedBox(width: 6),
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: _isTapped
                                  ? SizedBox(
                                      width: 45,
                                      child: Text(
                                        '\$${widget.trip.totalExpense.toStringAsFixed(0)}',
                                        key: ValueKey<bool>(_isTapped),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 45,
                                      key: ValueKey<bool>(_isTapped),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
