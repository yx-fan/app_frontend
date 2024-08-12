import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../widgets/category_icons.dart';
import '../views/expense_detail_view.dart';

class ExpenseCard extends StatefulWidget {
  final Expense expense;
  final void Function(bool) onStarred;
  final void Function(Expense) onUpdate;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onStarred,
    required this.onUpdate,
  });

  @override
  _ExpenseCardState createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  late bool isStarred;

  @override
  void initState() {
    super.initState();
    isStarred = widget.expense.starred;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedExpense = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseDetailView(
              expense: widget.expense,
              isEditable: true,
              isDeletable: true,
            ),
          ),
        );
        if (updatedExpense != null) {
          widget.onUpdate(updatedExpense);
        }
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color.fromARGB(129, 116, 115, 115),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    CategoryIcons().getCategoryColor(widget.expense.category),
                radius: 28,
                child: Icon(
                  CategoryIcons().getCategoryIcon(widget.expense.category),
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 36,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.expense.merchantName,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '\$${widget.expense.amount.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right, size: 24),
                                onPressed: () async {
                                  final updatedExpense = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExpenseDetailView(
                                        expense: widget.expense,
                                        isEditable: true,
                                        isDeletable: true,
                                      ),
                                    ),
                                  );
                                  if (updatedExpense != null) {
                                    widget.onUpdate(updatedExpense);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 27,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.expense.date}'.split(' ')[0],
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                          IconButton(
                            icon: Icon(
                              isStarred
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isStarred
                                  ? const Color.fromARGB(194, 241, 147, 6)
                                  : const Color.fromARGB(194, 241, 147, 6),
                              size: 24,
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
      ),
    );
  }
}
