import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../widgets/category_icons.dart';

class ExpenseCard extends StatefulWidget {
  final Expense expense;
  final void Function(bool) onStarred;
  final bool isStarred;

  ExpenseCard({
    required this.expense,
    required this.onStarred,
    required this.isStarred,
  });

  @override
  _ExpenseCardState createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  late bool isStarred;

  @override
  void initState() {
    super.initState();
    isStarred = widget.isStarred;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 251, 247, 244), // Light orange background
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: Color.fromARGB(255, 244, 216, 174),
            width: 0.5), // Orange border
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 18),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  CategoryIcons().getCategoryColor(widget.expense.category),
              radius: 28, // Adjust the radius for larger size
              child: Icon(
                CategoryIcons().getCategoryIcon(widget.expense.category),
                color: Colors.white,
                size: 18, // Adjust the size of the category icon
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.expense.title,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${widget.expense.amount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.chevron_right,
                                  size:
                                      24), // Adjust the size of the arrow icon
                              onPressed: () {
                                // Navigate to expense details page
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 27,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.expense.date.toLocal()}'.split(' ')[0],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isStarred ? Icons.favorite : Icons.favorite_border,
                            color: isStarred
                                ? Color.fromARGB(194, 241, 147, 6)
                                : Color.fromARGB(194, 241, 147, 6),
                            size: 24, // Adjust the size of the heart icon
                          ),
                          onPressed: () {
                            setState(() {
                              isStarred = !isStarred;
                            });
                            widget.onStarred(isStarred);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
