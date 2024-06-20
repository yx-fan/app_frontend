import 'package:app_frontend/viewmodels/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapReceipt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    if (viewModel.selectedReceipt != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.white,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.selectedReceipt!.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${viewModel.selectedReceipt!.date.year}/${viewModel.selectedReceipt!.date.month}/${viewModel.selectedReceipt!.date.day}',
              ),
              Text(
                '\$${viewModel.selectedReceipt!.amount}', //${viewModel.selectedReceipt!.currency}',
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
