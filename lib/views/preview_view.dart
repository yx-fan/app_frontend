import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/preview_view_model.dart';
import 'create_expense_view.dart'; // 导入 CreateExpenseView
// 导入 Expense 模型

class PreviewView extends StatelessWidget {
  final String imagePath;
  final String tripId; // 添加 tripId

  const PreviewView({super.key, required this.imagePath, required this.tripId}); // 更新构造函数

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreviewViewModel(imagePath: imagePath, tripId: tripId), // 传递 tripId
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Preview'),
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
                      child: const Text('Retake'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await previewViewModel.uploadImage();
                        if (previewViewModel.parsedReceipt != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateExpenseView(
                                imagePath: imagePath, // 传递图像路径
                                receiptData: previewViewModel.parsedReceipt!, // 传递解析后的数据
                                tripId: tripId, // 传递 tripId
                              ),
                            ),
                          );
                        } else {
                          // 处理上传失败的情况
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to upload receipt')),
                          );
                        }
                      },
                      child: const Text('Confirm'),
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
