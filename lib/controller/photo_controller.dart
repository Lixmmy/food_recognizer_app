import 'package:flutter/material.dart';
import 'package:food_recognizer_app/service/image_picker_service.dart';

class PhotoController extends ChangeNotifier {
  final ImagePickerService _photoPicker;

  PhotoController(this._photoPicker);

  List<String>? _paths = [];
  List<String>? _previousPaths = []; 

  List<String>? get paths => _paths;
  List<String>? get previousPaths => _previousPaths;

  Future<void> getPhoto(BuildContext context) async {
    final newPaths = await _photoPicker.pickImage(context);
    // Hanya update jika user memilih foto baru (tidak null)
    if (newPaths != null) {
      _previousPaths = _paths; // Simpan foto lama
      _paths = newPaths;
      notifyListeners();
    }
  }

  Future<void> clearPhoto() async {
    _paths = [];
    _previousPaths = [];
    notifyListeners();
  }

  Future<void> getCameraPhoto(BuildContext context) async {
    final newPaths = await _photoPicker.pickCameraImage(context);
    // Hanya update jika user berhasil mengambil foto (tidak null)
    if (newPaths != null) {
      _previousPaths = _paths; // Simpan foto lama
      _paths = newPaths;
      notifyListeners();
    }
  }

  // Method untuk kembali ke foto sebelumnya
  void restorePreviousPhoto() {
    if (_previousPaths != null && _previousPaths!.isNotEmpty) {
      _paths = _previousPaths;
      _previousPaths = [];
      notifyListeners();
    }
  }
}