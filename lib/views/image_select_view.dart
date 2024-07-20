import 'package:app_frontend/widgets/theme_button_large.dart';
import 'package:flutter/material.dart';
import 'camera_view.dart';
import 'package:image_picker/image_picker.dart';
import 'trip_picture_preview_view.dart';

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
                      Navigator.pop(context, imagePath);
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
                onPressed: () async {
                  // Navigate to CameraView
                  final XFile? picture = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraView(
                        title: "Upload Trip Page",
                        captureIcon: Icons.camera,
                        overlay: _buildOverlay(),
                        onPictureTaken: (XFile picture) {
                          Navigator.pop(context, picture);
                        },
                      ),
                    ),
                  );
                  if (picture != null) {
                    // Navigate to TripPicturePreviewView
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripPicturePreviewView(
                          imagePath: picture.path,
                          onRetake: () async {
                            // Handle retake, navigate back to CameraView
                            final XFile? retakenPicture = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraView(
                                  title: "Retake Trip Page",
                                  captureIcon: Icons.camera,
                                  overlay: _buildOverlay(),
                                  onPictureTaken: (XFile picture) {
                                    Navigator.pop(context, picture);
                                  },
                                ),
                              ),
                            );
                            if (retakenPicture != null) {
                              Navigator.pop(context, retakenPicture.path);
                            }
                          },
                        ),
                      ),
                    );
                    if (result != null) {
                      onImageSelected(result);
                      Navigator.pop(context, result);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Stack(
      children: [
        Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          child: Container(
            width: 20,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        Positioned(
          right: 20,
          top: 0,
          bottom: 0,
          child: Container(
            width: 20,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
