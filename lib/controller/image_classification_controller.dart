import 'package:flutter/material.dart';
import 'package:food_recognizer_app/service/image_classification_service.dart';

class ImageClassificationController extends ChangeNotifier {
  final ImageClassificationService _service;

  Map<String, double> _classification = {};

  Map<String, double> get classificationResult {
    final entries = _classification.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(entries.take(3));
  }

  ImageClassificationController(this._service);

  Future<void> initialize() async {
    await _service.initialize();
  }

  Future<void> runClassification(String imagePath) async {
    _classification = await _service.inferenceImage(imagePath);

    notifyListeners();
  }

  void close() async {
    await _service.close();
  }
}
