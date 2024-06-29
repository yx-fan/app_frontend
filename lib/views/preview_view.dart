import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/preview_view_model.dart';
import 'expense_detail_view.dart';
import '../models/expense_model.dart'; // 导入 Expense 模型

class PreviewView extends StatelessWidget {
  final String imagePath;

  PreviewView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreviewViewModel(imagePath: imagePath),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Preview'),
        ),
        body: Consumer<PreviewViewModel>(
          builder: (context, previewViewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: Image.file(File(imagePath)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Retake'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await previewViewModel.uploadImage();
                        if (previewViewModel.parsedReceipt != null) {
                          // 假设 parsedReceipt 已经是一个 Expense 对象
                          Expense expense = Expense.fromJson(previewViewModel.parsedReceipt!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpenseDetailView(
                                expense: expense,
                                isEditable: true, // 根据需要设置是否可编辑
                                isDeletable: false, // 根据需要设置是否可删除
                              ),
                            ),
                          );
                        } else {
                          // Handle upload failure
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to upload receipt')),
                          );
                        }
                      },
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
