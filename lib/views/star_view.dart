import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/expense_card.dart';
import '../viewmodels/star_view_model.dart';
import '../views/filter_view.dart';

class StarScreen extends StatefulWidget {
  const StarScreen({super.key});

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
        title: const Text("Starred"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
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

          if (expensesToDisplay.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No starred expenses yet!',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8), // Add some space between the two lines
                    Text(
                      'Go to trip details and heart some expenses to get started.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

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
                      style: const TextStyle(
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
                  }),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
