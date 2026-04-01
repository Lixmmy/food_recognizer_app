import 'package:flutter/material.dart';
import 'package:food_recognizer_app/service/image_picker_service.dart';

class PhotoController extends ChangeNotifier {
  final ImagePickerService _photoPicker;

  PhotoController(this._photoPicker);

  String? _paths;
  String? _previousPaths; 

  String? get paths => _paths;
  String? get previousPaths => _previousPaths;

  Future<void> getPhoto(BuildContext context) async {
    final newPaths = await _photoPicker.pickImage(context);
    if (newPaths != null) {
        _previousPaths = _paths; 
        _paths = newPaths; 
        notifyListeners();
    }
  }

  Future<void> clearPhoto() async {
    _paths = null;
    _previousPaths = null;
    notifyListeners();
  }

  Future<void> getCameraPhoto(BuildContext context) async {
    final newPaths = await _photoPicker.pickCameraImage(context);
    if (newPaths != null) {
      _previousPaths = _paths; 
      _paths = newPaths; 
      notifyListeners();
    }
  }

  Future<void> updatePhotoPath(String newPath) async {
    _previousPaths = _paths;
    _paths = newPath;
    notifyListeners();
  }

}