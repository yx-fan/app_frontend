import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../viewmodels/trip_expense_view_model.dart';
import '../widgets/theme_button_small.dart';
import '../viewmodels/trip_view_model.dart';

class ExpenseDetailView extends StatefulWidget {
  final Expense expense;
  final bool isEditable; // 是否允许编辑
  final bool isDeletable; // 是否允许删除

  const ExpenseDetailView({super.key, 
    required this.expense,
    this.isEditable = true,
    this.isDeletable = true,
  });

  @override
  _ExpenseDetailViewState createState() => _ExpenseDetailViewState();
}

class _ExpenseDetailViewState extends State<ExpenseDetailView> {
  late TextEditingController _merchantController;
  late TextEditingController _dateController;
  late TextEditingController _amountController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late int _selectedCategory;
  double _oldAmt = 0;

  @override
  void initState() {
    super.initState();
    _merchantController =
        TextEditingController(text: widget.expense.merchantName);
    _dateController =
        TextEditingController(text: widget.expense.date.toIso8601String());
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _locationController = TextEditingController(text: widget.expense.location);
    _descriptionController =
        TextEditingController(text: widget.expense.description);
    _selectedCategory = widget.expense.category;
    _oldAmt = widget.expense.amount;
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TripExpenseViewModel>(context, listen: false);
    final tripViewModel = Provider.of<TripViewModel>(context, listen: false);
    String currTripID = viewModel.tripId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回上一页
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _merchantController,
              decoration: InputDecoration(
                labelText: 'Merchant Name',
                suffixIcon: widget.isEditable ? const Icon(Icons.edit) : null,
              ),
              readOnly: !widget.isEditable,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              readOnly: !widget.isEditable,
              maxLines: null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: viewModel.categoryMap.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: widget.isEditable
                  ? (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
              ),
              readOnly: !widget.isEditable,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              readOnly: !widget.isEditable,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
              ),
              readOnly: !widget.isEditable,
            ),
            const SizedBox(height: 20),
            const Text('Receipt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.network('https://via.placeholder.com/150'),
                      const Text('Main'),
                    ],
                  ),
                ),
                const Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.add, size: 50),
                      Text('Additional'),
                    ],
                  ),
                ),
                const Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.add, size: 50),
                      Text('Additional'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.isDeletable)
                  TextButton(
                    onPressed: () async {
                      bool confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this expense?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // 返回 false 表示不删除
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // 返回 true 表示确认删除
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed) {
                        await viewModel.deleteExpense(widget.expense.id);
                        tripViewModel.updateCnt(currTripID, 0, _oldAmt);
                        Navigator.pop(context, true); // 返回上一页，传递 true 以触发刷新
                      }
                    },
                    child: const Text(
                      'Delete expense',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                const Spacer(),
                ThemeButtonSmall(
                  text: 'Save changes',
                  onPressed: () async {
                    final updatedExpense = Expense(
                      id: widget.expense.id,
                      merchantName: _merchantController.text,
                      date: DateTime.parse(_dateController.text),
                      amount: double.parse(_amountController.text),
                      location: _locationController.text,
                      description: _descriptionController.text,
                      category: _selectedCategory,
                      postalCode:
                          widget.expense.postalCode, // Use original value
                      latitude: widget.expense.latitude, // Use original value
                      longitude: widget.expense.longitude, // Use original value
                    );
                    await viewModel.saveChanges(widget.expense, updatedExpense);
                    tripViewModel.updateAmt(currTripID, _oldAmt,
                        double.parse(_amountController.text));
                    Navigator.pop(context, updatedExpense); // 返回修改后的 expense 对象
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
