import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  Future<List<String>?> pickImage(BuildContext context) async {
    try {
      bool hasPermission = await _checkPermission(context);
      if (!hasPermission) {
        return null;
      }
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      return images.map((image) => image.path).toList();
    } catch (e) {
      return null;
    }
  }
  Future<List<String>?> pickCameraImage(BuildContext context) async {
    try {
      bool hasPermission = await _checkPermission(context);
      if (!hasPermission) {
        return null;
      }
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        return [image.path];
      } else {
        return null;
      }
    } catch (e) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission denied. Please grant permission to access photos.',
          ),
        ),
      );
    }
    return hasPermission;
  }
}
