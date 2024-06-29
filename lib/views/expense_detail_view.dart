import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../viewmodels/trip_expense_view_model.dart';
import '../widgets/theme_button_small.dart'; // 导入 ThemeButtonSmall

class ExpenseDetailView extends StatefulWidget {
  final Expense expense;
  final bool isEditable; // 是否允许编辑
  final bool isDeletable; // 是否允许删除

  ExpenseDetailView({
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
  late TextEditingController _postalCodeController; // 新增
  late TextEditingController _latitudeController; // 新增
  late TextEditingController _longitudeController; // 新增

  @override
  void initState() {
    super.initState();
    _merchantController = TextEditingController(text: widget.expense.merchantName ?? '');
    _dateController = TextEditingController(text: widget.expense.date.toIso8601String());
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _locationController = TextEditingController(text: widget.expense.location ?? '');
    _descriptionController = TextEditingController(text: widget.expense.description ?? '');
    _selectedCategory = widget.expense.category;
    _postalCodeController = TextEditingController(text: widget.expense.postalCode ?? ''); // 初始化
    _latitudeController = TextEditingController(text: widget.expense.latitude.toString()); // 初始化
    _longitudeController = TextEditingController(text: widget.expense.longitude.toString()); // 初始化
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _postalCodeController.dispose(); // 释放资源
    _latitudeController.dispose(); // 释放资源
    _longitudeController.dispose(); // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TripExpenseViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                suffixIcon: widget.isEditable ? Icon(Icons.edit) : null,
              ),
              readOnly: !widget.isEditable,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              readOnly: !widget.isEditable,
              maxLines: null,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _selectedCategory,
              decoration: InputDecoration(
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
            SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
              ),
              readOnly: !widget.isEditable,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              readOnly: !widget.isEditable,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
              readOnly: !widget.isEditable,
            ),
            SizedBox(height: 20),
            Text('Receipt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.network('https://via.placeholder.com/150'),
                      Text('Main'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.add, size: 50),
                      Text('Additional'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.add, size: 50),
                      Text('Additional'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.isDeletable)
                  TextButton(
                    onPressed: () async {
                      await viewModel.deleteExpense(widget.expense.id);
                      Navigator.pop(context, true); // Return to the previous page and trigger refresh
                    },
                    child: Text(
                      'Delete expense',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                Spacer(),
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
                      postalCode: widget.expense.postalCode, // Use original value
                      latitude: widget.expense.latitude, // Use original value
                      longitude: widget.expense.longitude, // Use original value
                    );
                    await viewModel.saveChanges(widget.expense, updatedExpense);
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
