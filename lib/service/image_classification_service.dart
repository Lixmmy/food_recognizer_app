import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:food_recognizer_app/service/isolate_inference.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  final modelPath = 'assets/model/food_classifier.tflite';
  final labelsPath = 'assets/model/labels.txt';

  late final Interpreter _interpreter;
  late final List<String> labels;
  late Tensor _inputTensor;
  late Tensor _outputTensor;
  late final IsolateInference isolateInference;

  Future<void> loadModel() async {
    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    _interpreter = await Interpreter.fromAsset(modelPath, options: options);
    _inputTensor = _interpreter.getInputTensor(0);
    _outputTensor = _interpreter.getOutputTensor(0);

    log(
      'Model loaded successfully with input shape: ${_inputTensor.shape} and output shape: ${_outputTensor.shape}',
    );
  }

  Future<void> loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');

    log(
      'Labels loaded successfully with ${labelTxt.split('\n').length} labels',
    );
  }

  Future<Map<String, double>> inferenceImage(String path) async {
    final responsePort = ReceivePort();

    final isolateModel = InferenceModel(
      path,
      _interpreter.address,
      labels,
      _inputTensor.shape,
      _outputTensor.shape,
    )..responsePort = responsePort.sendPort;
    isolateInference.sendPort.send(isolateModel);

    final result = await responsePort.first;
    responsePort.close();

    return Map<String, double>.from(result as Map);
  }

  Future<void> close() async {
    await isolateInference.close();
  }

  Future<void> initialize() async {
    await loadModel();
    await loadLabels();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }
}
