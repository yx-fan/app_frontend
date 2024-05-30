import '../models/expense_model.dart';

class ExpenseService {
  Future<List<ExpenseModel>> fetchExpenses() async {
    // 模拟 API 调用
    await Future.delayed(Duration(seconds: 2));
    return [
      ExpenseModel(
        id: '1',
        title: 'Trip A',
        description: 'Trip to city A',
        startTime: DateTime.now().subtract(Duration(hours: 2)),
        endTime: DateTime.now().subtract(Duration(hours: 1)),
        category: 'Travel',
      ),
      // 添加更多模拟数据
    ];
  }
}
