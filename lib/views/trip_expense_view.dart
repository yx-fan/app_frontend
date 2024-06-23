import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip_model.dart';
import '../widgets/expense_card.dart';
import '../viewmodels/trip_expense_view_model.dart';

class TripExpenseView extends StatelessWidget {
  final Trip trip;

  TripExpenseView({required this.trip});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripExpenseViewModel(tripId: trip.tripId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(trip.tripName),
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
              child: Consumer<TripExpenseViewModel>(
                builder: (context, viewModel, child) {
                  return ListView.builder(
                    itemCount: viewModel.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = viewModel.expenses[index];
                      return ExpenseCard(
                        expense: expense,
                        onStarred: (isStarred) {
                          viewModel.toggleStarredExpense(expense);
                        },
                        isStarred: viewModel.starredExpenses.contains(expense),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
