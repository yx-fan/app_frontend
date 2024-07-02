import 'package:app_frontend/viewmodels/currency_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/map_view.dart';
import '../views/trip_expense_view.dart';
import '../views/receipt_camera_view.dart'; // 导入 ReceiptCameraPage
import "../models/trip_model.dart";
import '../widgets/theme_button_small.dart';

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
    final viewModel = Provider.of<CurrencyViewModel>(context, listen: false);
    String currency = viewModel.currencies[widget.trip.currencyId] ?? "USD";
    return Container(
      height: 350,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 18),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trip.tripName,
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
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      // Implement camera functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptCameraPage(
                              tripId: widget.trip.tripId), // 传递 tripId
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 16 / 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
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
                      ThemeButtonSmall(
                        text: 'Map',
                        onPressed: () {
                          // Implement map functionality
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapView(
                                tripID: widget.trip.tripId,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 8),
                      ThemeButtonSmall(
                        text: 'Details',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TripExpenseView(trip: widget.trip),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: 100),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt),
                          SizedBox(width: 6),
                          SizedBox(
                            width: 45,
                            child: Text('${widget.trip.totalCnt}'),
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
                                        '${widget.trip.totalAmt.round()}',
                                        key: ValueKey<bool>(_isTapped),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 45,
                                      child: Text(
                                        currency,
                                        key: ValueKey<bool>(_isTapped),
                                      ),
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
