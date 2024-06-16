import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import '../widgets/expense_card.dart';

class TripExpenseView extends StatefulWidget {
  final Trip trip;

  TripExpenseView({required this.trip});

  @override
  _TripExpenseViewState createState() => _TripExpenseViewState();
}

class _TripExpenseViewState extends State<TripExpenseView> {
  List<Expense> starredExpenses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Past Expenses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.trip.expenses.length,
              itemBuilder: (context, index) {
                final expense = widget.trip.expenses[index];
                return ExpenseCard(
                  expense: expense,
                  onStarred: (isStarred) {
                    setState(() {
                      if (isStarred) {
                        starredExpenses.add(expense);
                      } else {
                        starredExpenses.remove(expense);
                      }
                    });
                  },
                  isStarred: starredExpenses.contains(expense),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 80,
            color: Colors.orange, // Navigation bar style
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 253, 253, 253),
                foregroundColor: Color.fromARGB(194, 241, 147, 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                // Implement capturing more expenses
              },
              child: Text('Capture More Expenses',
                  style: TextStyle(
                      color: Color.fromARGB(194, 241, 147, 6), fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
