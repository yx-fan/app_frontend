import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class MapExpense extends StatelessWidget {
  final Expense expense;

  const MapExpense({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.merchantName,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(
                  expense.starred ? Icons.favorite : Icons.favorite_border,
                  color: Color.fromARGB(194, 241, 147, 6),
                  size: 26,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              '${expense.date.year}/${expense.date.month}/${expense.date.day}\n\$${expense.amount}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
