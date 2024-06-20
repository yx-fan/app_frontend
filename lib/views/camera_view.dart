import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../viewmodels/camera_view_model.dart';
import 'preview_view.dart';

class CameraView extends StatelessWidget {
  final Function(XFile) onPictureTaken;
  final String title;
  final IconData captureIcon;
  final Widget? overlay;

  CameraView({
    required this.onPictureTaken,
    required this.title,
    required this.captureIcon,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraViewModel(),
      child: Consumer<CameraViewModel>(
        builder: (context, cameraViewModel, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(title, style: TextStyle(color: Colors.white)),
            ),
            body: cameraViewModel.isCameraInitialized
                ? Stack(
              children: [
                CameraPreview(cameraViewModel.cameraController!),
                if (overlay != null) overlay!,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          heroTag: "galleryButton",
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: Icon(Icons.photo_library, color: Colors.black, size: 30),
                          onPressed: () {
                            cameraViewModel.pickImageFromGallery();
                          },
                        ),
                        FloatingActionButton(
                          heroTag: "cameraButton",
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(captureIcon, color: Colors.white, size: 30),
                          onPressed: () async {
                            XFile? picture = await cameraViewModel.takePicture();
                            if (picture != null) {
                              onPictureTaken(picture);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
                : Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
