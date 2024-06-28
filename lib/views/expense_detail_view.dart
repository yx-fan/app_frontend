import 'package:flutter/material.dart';
import '../models/expense_model.dart';
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

  static final _categoryMap = {
    1: "Transportation",
    2: "Food",
    3: "Entertainment",
    4: "Accommodation",
    5: "Shopping",
    6: "Other"
  };

  @override
  void initState() {
    super.initState();
    _merchantController = TextEditingController(text: widget.expense.merchantName);
    _dateController = TextEditingController(text: widget.expense.date.toIso8601String());
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _locationController = TextEditingController(text: widget.expense.location);
    _descriptionController = TextEditingController(text: widget.expense.description);
    _selectedCategory = widget.expense.category;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
              items: _categoryMap.entries.map((entry) {
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
                    onPressed: () {
                      // Handle delete action
                    },
                    child: Text(
                      'Delete expense',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                Spacer(),
                ThemeButtonSmall(
                  text: 'Save changes',
                  onPressed: () {
                    // Handle save changes
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
