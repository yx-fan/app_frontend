import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip_model.dart';
import '../widgets/expense_card.dart';
import '../viewmodels/trip_expense_view_model.dart';
import '../viewmodels/star_view_model.dart';
import '../views/filter_view.dart';

class TripExpenseView extends StatefulWidget {
  final Trip trip;

  const TripExpenseView({super.key, required this.trip});

  @override
  _TripExpenseViewState createState() => _TripExpenseViewState();
}

class _TripExpenseViewState extends State<TripExpenseView> {
  List<String> selectedCategories = [];
  String sortOption = 'Newest';

  late Future<void> _fetchExpensesFuture;

  @override
  void initState() {
    super.initState();
    _fetchExpensesFuture =
        Provider.of<TripExpenseViewModel>(context, listen: false)
            .fetchExpenseDetails(widget.trip.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.tripName),
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
                Provider.of<TripExpenseViewModel>(context, listen: false)
                    .filterAndSortExpenses(
                  selectedCategories,
                  sortOption,
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _fetchExpensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading expenses'));
          } else {
            return Consumer2<TripExpenseViewModel, StarViewModel>(
              builder: (context, tripExpenseViewModel, starViewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20, horizontal: 18),
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
                        itemCount:
                            tripExpenseViewModel.filteredExpenses.isNotEmpty
                                ? tripExpenseViewModel.filteredExpenses.length
                                : tripExpenseViewModel.expenses.length,
                        itemBuilder: (context, index) {
                          final expense =
                              tripExpenseViewModel.filteredExpenses.isNotEmpty
                                  ? tripExpenseViewModel.filteredExpenses[index]
                                  : tripExpenseViewModel.expenses[index];
                          return ExpenseCard(
                            expense: expense,
                            onStarred: (isStarred) {
                              starViewModel.toggleStarredExpense(
                                  widget.trip.tripId, expense);
                            },
                            onUpdate: (updatedExpense) {
                              tripExpenseViewModel
                                  .updateExpense(updatedExpense);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
