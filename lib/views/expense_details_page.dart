import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/expense_viewmodel.dart';
import '../widgets/expense_card.dart';

class ExpenseDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseViewModel()..fetchExpenses(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Expense Details'),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<ExpenseViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (viewModel.expenses == null) {
              return Center(child: Text('No expenses found'));
            }
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildDashboardItem('7', 'Create New Trip'),
                    _buildDashboardItem('16', 'Capture Receipts'),
                    _buildDashboardItem('3', 'Expense Log'),
                    _buildDashboardItem('1', 'Track Spending'),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Today's expenses",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...viewModel.expenses!.map((expense) => ExpenseCard(expense: expense)).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardItem(String number, String label) {
    return Card(
      elevation: 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
