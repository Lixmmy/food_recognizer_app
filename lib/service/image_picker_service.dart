import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  Future<String?> pickImage(BuildContext context) async {
    try {
      bool hasPermission = await _checkPermission(context);
      if (!hasPermission) {
        return null;
      }
      final ImagePicker picker = ImagePicker();
      final XFile? images = await picker.pickImage(source: ImageSource.gallery);

      return images?.path;
    } catch (e) {
      return null;
    }
  }
  Future<String?> pickCameraImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      return image?.path;
    } catch (e) {
      debugPrint('pickCameraImage error: $e');
      return null;
    }
  }

  Future<bool> _checkPermission(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos,
    ].request();
    bool hasPermission =
        statuses[Permission.photos]!.isGranted ||
        statuses[Permission.storage]!.isGranted;
    if (!hasPermission) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission denied. Please grant permission to access camera and photos.',
          ),
        ),
      );
    }
    return hasPermission;
  }
}
