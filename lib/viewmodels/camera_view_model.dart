import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class CameraViewModel extends ChangeNotifier {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  bool isInitializing = false;

  CameraViewModel() {
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    bool granted = await _requestCameraPermission();
    if (granted) {
      initializeCamera();
    } else {
      print("Camera permission not granted");
    }
  }

  Future<bool> _requestCameraPermission() async {
    try {
      var status = await const MethodChannel('flutter.native/helper').invokeMethod('checkCameraPermission');
      if (status == 'granted') {
        return true;
      } else {
        var result = await const MethodChannel('flutter.native/helper').invokeMethod('requestCameraPermission');
        return result == 'granted';
      }
    } catch (e) {
      print("Error requesting camera permission: $e");
      return false;
    }
  }

  Future<void> initializeCamera() async {
    try {
      isInitializing = true;
      notifyListeners();

      cameras = await availableCameras();
      if (cameras!.isNotEmpty) {
        cameraController = CameraController(cameras![0], ResolutionPreset.high);
        await cameraController!.initialize();
        isCameraInitialized = true;
        isInitializing = false;
        notifyListeners();
      }
    } catch (e) {
      isInitializing = false;
      notifyListeners();
      print("Error initializing camera: $e");
    }
  }

  Future<XFile?> takePicture() async {
    if (!cameraController!.value.isInitialized) {
      return null;
    }
    if (cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      XFile picture = await cameraController!.takePicture();
      return picture;
    } catch (e) {
      print("Error taking picture: $e");
      return null;
    }
  }

  void pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // handle picked image
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
