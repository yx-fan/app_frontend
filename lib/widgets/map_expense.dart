import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class MapExpense extends StatelessWidget {
  final Expense expense;

  MapExpense({required this.expense});

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
              expense.merchantName,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${expense.date.year}/${expense.date.month}/${expense.date.day}',
            ),
            Text(
              '\$${expense.amount}', //${expense.currency}',
            ),
          ],
        ),
      ),
    );
  }
}
