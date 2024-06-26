import 'package:flutter/material.dart';
import '../models/map_model.dart';

class MapReceipt extends StatelessWidget {
  final Receipt receipt;

  MapReceipt({required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              receipt.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${receipt.date.year}/${receipt.date.month}/${receipt.date.day}',
            ),
            Text(
              '\$${receipt.amount}', //${receipt.currency}',
            ),
          ],
        ),
      ),
    );
  }
}
