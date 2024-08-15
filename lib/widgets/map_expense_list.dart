import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_frontend/models/expense_model.dart';
import 'package:app_frontend/viewmodels/map_view_model.dart';
import 'package:app_frontend/widgets/category_icons.dart';

class MapExpenseList extends StatefulWidget {
  const MapExpenseList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  State<MapExpenseList> createState() => _MapExpenseListState();
}

class _MapExpenseListState extends State<MapExpenseList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    String? selectedExpenseId;

    return DraggableScrollableSheet(
      snap: true,
      snapSizes: const [0.25],
      initialChildSize: 0.25,
      minChildSize: 0.1,
      maxChildSize: 0.4,
      builder: (ctx, scrollController) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                  width: 50,
                  child: Divider(
                    thickness: 5,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: widget.expenses.isEmpty
                      ? Center(
                          child: Text(
                            'No expense added yet.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.builder(
                          // physics: const ClampingScrollPhysics(),
                          controller: scrollController,
                          itemCount: widget.expenses.length,
                          itemBuilder: (ctx, index) {
                            final expense = widget.expenses[index];
                            return ListTile(
                              title: Text(
                                expense.merchantName,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                '${'${expense.date}'.split(' ')[0]}\n\$${expense.amount}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: Icon(
                                expense.starred
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: const Color.fromARGB(194, 241, 147, 6),
                                size: 24,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: CategoryIcons()
                                    .getCategoryColor(expense.category),
                                child: Icon(
                                  CategoryIcons()
                                      .getCategoryIcon(expense.category),
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              onTap: () {
                                viewModel.selectExpense(expense);
                                setState(() {
                                  selectedExpenseId = expense.id;
                                });
                              },
                              selected: selectedExpenseId == expense.id,
                              selectedTileColor: Colors.grey,
                            );
                          },
                        ),
                ),
              ],
            ));
      },
    );
  }
}
