import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  final modelPath = 'assets/models/food_classifier.tflite';
  final labelsPath = 'assets/models/labels.txt';

  late final Interpreter _interpreter;
  late final List<String> labels;
  late Tensor _inputTensor;
  late Tensor _outputTensor;

  Future<void> loadModel() async {
    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    _interpreter = await Interpreter.fromAsset(modelPath, options: options);
    _inputTensor = _interpreter.getInputTensor(0);
    _outputTensor = _interpreter.getOutputTensor(0);

    log( 'Model loaded successfully with input shape: ${_inputTensor.shape} and output shape: ${_outputTensor.shape}');
  }

  Future<void> loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');

    log('Labels loaded successfully with ${labelTxt.split('\n').length} labels');
  }

  Future<void> initialize() async {
    await loadModel();
    await loadLabels();
  }
}
