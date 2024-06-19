import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../viewmodels/camera_view_model.dart';
import 'preview_view.dart';

class CameraView extends StatelessWidget {
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
            ),
            body: cameraViewModel.isCameraInitialized
                ? Stack(
              children: [
                CameraPreview(cameraViewModel.cameraController!),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ),
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
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 30),
                          onPressed: () async {
                            XFile? picture = await cameraViewModel.takePicture();
                            if (picture != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreviewView(imagePath: picture.path),
                                ),
                              );
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
