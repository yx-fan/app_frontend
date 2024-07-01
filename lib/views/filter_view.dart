import 'dart:ffi';

import 'package:flutter/material.dart';
import '../widgets/theme_button_small.dart';

class FilterScreen extends StatefulWidget {
  final List<String> selectedCategories;
  final String sortOption;

  FilterScreen({required this.selectedCategories, required this.sortOption});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late List<String> selectedCategories;
  late String sortOption;

  @override
  void initState() {
    super.initState();
    selectedCategories = widget.selectedCategories;
    sortOption = widget.sortOption;
  }

  void _toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  void _applyFilter() {
    Navigator.pop(context, {
      'selectedCategories': selectedCategories,
      'sortOption': sortOption,
    });
  }

  void _clearAll() {
    setState(() {
      selectedCategories.clear();
      sortOption = 'Newest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(
                context); // Close the filter screen without applying filters
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type of Expense',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildCategoryRow(['Transportation', 'Food']),
            _buildCategoryRow(['Entertainment', 'Accommodation']),
            _buildCategoryRow(['Shopping', 'Other']),
            SizedBox(height: 20),
            Text(
              'Sort',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                _buildRadioListTile('Newest'),
                _buildRadioListTile('Amount: Low to High'),
                _buildRadioListTile('Amount: High to Low'),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _clearAll,
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ThemeButtonSmall(
                  text: 'Apply Filter',
                  onPressed: _applyFilter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioListTile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 2.0), // Reduce the vertical padding
      child: RadioListTile(
        dense: true, // Make the RadioListTile more compact
        contentPadding: EdgeInsets.zero, // Remove internal padding
        visualDensity: VisualDensity.compact, // Adjust visual density
        activeColor:
            Color.fromARGB(194, 241, 147, 6), // Set the active color to orange
        title: Text(title, style: TextStyle(fontSize: 16)), // Reduce font size
        value: title,
        groupValue: sortOption,
        onChanged: (value) {
          setState(() {
            sortOption = value.toString();
          });
        },
      ),
    );
  }

  Widget _buildCategoryRow(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: categories.map((category) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildCategoryChip(category),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      height: 75, // Set the desired height
      width: double.infinity, // Ensure it takes the available width
      decoration: BoxDecoration(
        color: selectedCategories.contains(category)
            ? Color.fromARGB(194, 241, 147, 6)
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _toggleCategory(category);
        },
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 16, // Adjust the text size
              color: selectedCategories.contains(category)
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
