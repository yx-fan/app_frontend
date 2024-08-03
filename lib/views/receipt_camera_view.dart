import 'package:flutter/material.dart';
import 'camera_view.dart';
import 'preview_view.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptCameraPage extends StatelessWidget {
  final String tripId; // 添加 tripId

  const ReceiptCameraPage({super.key, required this.tripId}); // 更新构造函数

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: "Capture Receipt",
      captureIcon: Icons.receipt_long,
      overlay: _buildOverlay(),
      onPictureTaken: (XFile picture) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewView(imagePath: picture.path, tripId: tripId), // 传递 tripId
          ),
        );
      },
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
