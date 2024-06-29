import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip_model.dart';
import '../widgets/expense_card.dart';
import '../viewmodels/trip_expense_view_model.dart';
import '../views/filter_view.dart';

class TripExpenseView extends StatefulWidget {
  final Trip trip;

  TripExpenseView({required this.trip});

  @override
  _TripExpenseViewState createState() => _TripExpenseViewState();
}

class _TripExpenseViewState extends State<TripExpenseView> {
  List<String> selectedCategories = [];
  String sortOption = 'Newest';

  @override
  void initState() {
    super.initState();
    Provider.of<TripExpenseViewModel>(context, listen: false).fetchExpenseDetails(widget.trip.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.tripName),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final filterCriteria = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(
                    selectedCategories: selectedCategories,
                    sortOption: sortOption,
                  ),
                ),
              );
              if (filterCriteria != null) {
                setState(() {
                  selectedCategories = filterCriteria['selectedCategories'];
                  sortOption = filterCriteria['sortOption'];
                });
                Provider.of<TripExpenseViewModel>(context, listen: false).filterAndSortExpenses(
                  selectedCategories,
                  sortOption,
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<TripExpenseViewModel>(
        builder: (context, viewModel, child) {
          return Column(
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
                  itemCount: viewModel.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = viewModel.filteredExpenses.isNotEmpty
                        ? viewModel.filteredExpenses[index]
                        : viewModel.expenses[index];
                    return ExpenseCard(
                      expense: expense,
                      onStarred: (isStarred) {
                        viewModel.toggleStarredExpense(expense);
                      },
                      isStarred: viewModel.starredExpenses.contains(expense),
                      onUpdate: (updatedExpense) {
                        viewModel.updateExpense(updatedExpense);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
