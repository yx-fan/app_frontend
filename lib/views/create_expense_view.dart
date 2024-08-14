import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/trip_expense_view_model.dart';
import '../viewmodels/trip_view_model.dart';

class CreateExpenseView extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> receiptData;
  final String tripId; // 添加 tripId 以便创建费用

  const CreateExpenseView(
      {super.key,
      required this.imagePath,
      required this.receiptData,
      required this.tripId});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TripExpenseViewModel>(context, listen: false);
    final tripViewModel = Provider.of<TripViewModel>(context, listen: false);
    double amt = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Expense'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.file(File(imagePath)),
                Positioned.fill(
                  child: CustomPaint(
                    painter: ReceiptPainter(receiptData),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: receiptData['merchantName'] ?? '',
                    decoration:
                        const InputDecoration(labelText: 'Merchant Name'),
                    onChanged: (value) => receiptData['merchantName'] = value,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: receiptData['date'] ?? '',
                    decoration: const InputDecoration(labelText: 'Date'),
                    onChanged: (value) => receiptData['date'] = value,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: receiptData['amount']?.toString() ?? '',
                    decoration: const InputDecoration(labelText: 'Amount'),
                    onChanged: (value) {
                      receiptData['amount'] = value;
                      amt = double.tryParse(value) ?? 0.0;
                      tripViewModel.updateCnt(tripId, 1, amt);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: receiptData['category'] ?? '',
                    decoration: const InputDecoration(labelText: 'Category'),
                    onChanged: (value) => receiptData['category'] = value,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: receiptData['location'] ?? '',
                    decoration: const InputDecoration(labelText: 'Location'),
                    onChanged: (value) => receiptData['location'] = value,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: receiptData['description'] ?? '',
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) => receiptData['description'] = value,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Discard'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await viewModel.createExpense(tripId, receiptData);
                    tripViewModel.fetchTrips();
                    Navigator.popUntil(context,
                        ModalRoute.withName('/tripView')); // 回到 trip 主页面
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReceiptPainter extends CustomPainter {
  final Map<String, dynamic> receiptData;

  ReceiptPainter(this.receiptData);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    final textSpan = TextSpan(
      text: formatReceipt(receiptData),
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    const offset = Offset(20, 40);
    textPainter.paint(canvas, offset);
  }

  String formatReceipt(Map<String, dynamic> receiptData) {
    return '''
Merchant: ${receiptData['merchantName'] ?? 'N/A'}
Date: ${receiptData['date'] ?? 'N/A'}
Amount: ${receiptData['amount'] ?? 'N/A'}
Category: ${receiptData['category'] ?? 'N/A'}
Location: ${receiptData['location'] ?? 'N/A'}
Description: ${receiptData['description'] ?? 'N/A'}
''';
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
