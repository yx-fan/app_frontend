import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/preview_view_model.dart';

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
                      onPressed: () {
                        previewViewModel.uploadImage();
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
