import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../models/trip_model.dart';
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
        ],
      ),
    );
  }
}
