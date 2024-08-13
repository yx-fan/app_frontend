import 'package:app_frontend/viewmodels/currency_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/map_view.dart';
import '../views/trip_expense_view.dart';
import '../views/receipt_camera_view.dart'; // Import ReceiptCameraPage
import "../models/trip_model.dart";
import '../widgets/theme_button_small.dart';
import '../views/trip_edit_view.dart'; // Import TripEditPage
import '../viewmodels/trip_view_model.dart';

class TripCard extends StatefulWidget {
  final Trip trip;
  final String formattedDate;

  const TripCard({super.key, required this.trip, required this.formattedDate});

  @override
  _TripCardState createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CurrencyViewModel>(context, listen: false);
    String currency = viewModel.currencies[widget.trip.currencyId] ?? "USD";

    return SizedBox(
      height: 350,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Starting Date: ${widget.formattedDate}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          // Navigate to the camera page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptCameraPage(
                                tripId: widget.trip.tripId,
                              ), // Pass the tripId to the camera page
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTripView(
                                trip: widget.trip,
                              ),
                            ),
                          );

                          if (result == true) {
                            print(
                                'Edit trip result received, refreshing trips'); // Debug print
                            Provider.of<TripViewModel>(context, listen: false)
                                .fetchTrips();
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200, // Set a specific height for the image
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    widget.trip.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        ThemeButtonSmall(
                          text: 'Map',
                          onPressed: () {
                            // Navigate to the map view
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
                        const SizedBox(width: 8),
                        ThemeButtonSmall(
                          text: 'Details',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  print("Current Trip");
                                  print(widget.trip.tripName);
                                  return TripExpenseView(trip: widget.trip);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.receipt),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 45,
                            child: Text('${widget.trip.totalCnt}'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                            const SizedBox(width: 6),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
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
