import 'package:app_frontend/widgets/theme_button_large.dart';
import 'package:flutter/material.dart';

class ImageSelectionView extends StatelessWidget {
  final Function(String) onImageSelected;

  ImageSelectionView({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 400, // Set a specific height for the grid
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: 9, // 9 images (index 0 to 8)
                itemBuilder: (context, index) {
                  final imagePath =
                      'assets/trip_img$index.jpg'; // Example image paths
                  return GestureDetector(
                    onTap: () {
                      onImageSelected(imagePath);
                      Navigator.pop(context);
                    },
                    child: Image(
                      image: ResizeImage(
                        AssetImage(imagePath),
                        width: 100, // Resize the image width
                        height: 100, // Resize the image height
                      ),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30), // Add space between the grid and the button
            Align(
              alignment: Alignment.center,
              child: ThemeButtonLarge(
                text: 'Upload from Camera',
                onPressed: () {
                  // Implement image upload from camera
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
