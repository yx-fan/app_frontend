import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip_model.dart';
import '../widgets/expense_card.dart';
import '../viewmodels/star_view_model.dart';
import '../views/filter_view.dart';

class StarScreen extends StatefulWidget {
  @override
  _StarViewState createState() => _StarViewState();
}

class _StarViewState extends State<StarScreen> {
  List<String> selectedCategories = [];
  String sortOption = 'Newest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Starred"),
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
                Provider.of<StarViewModel>(context, listen: false)
                    .filterAndSortExpenses(
                  selectedCategories,
                  sortOption,
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<StarViewModel>(
        builder: (context, viewModel, child) {
          final expensesToDisplay = viewModel.filteredExpenses.isNotEmpty
              ? viewModel.filteredExpenses
              : viewModel.starredExpenses;

          return ListView(
            children: expensesToDisplay.entries.map((entry) {
              final tripId = entry.key;
              final expenses = entry.value;
              final trip =
                  viewModel.trips.firstWhere((trip) => trip.tripId == tripId);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 18),
                    child: Text(
                      trip.tripName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...expenses.map((expense) {
                    return ExpenseCard(
                      expense: expense,
                      onStarred: (isStarred) {
                        viewModel.toggleStarredExpense(tripId, expense);
                      },
                      onUpdate: (updatedExpense) {
                        viewModel.updateExpense(tripId, updatedExpense);
                      },
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
