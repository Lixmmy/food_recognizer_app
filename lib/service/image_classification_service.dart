import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:food_recognizer_app/service/firebase_ml_service.dart';
import 'package:food_recognizer_app/service/isolate_inference.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  final FirebaseMlService _mlService;
  static const String labelsPath = 'assets/model/labels.txt';

  ImageClassificationService(this._mlService);

  late final File modelFile;

  late final Interpreter _interpreter;
  late final List<String> labels;
  late Tensor _inputTensor;
  late Tensor _outputTensor;
  late final IsolateInference isolateInference;

  Future<void> loadModel() async {
    modelFile = await _mlService.loadModel();
    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    _interpreter =  Interpreter.fromFile(modelFile, options: options);
    _inputTensor = _interpreter.getInputTensor(0);
    _outputTensor = _interpreter.getOutputTensor(0);

    log(
      'Model loaded successfully with input shape: ${_inputTensor.shape} and output shape: ${_outputTensor.shape}',
    );
  }

  Future<void> loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    log(
      'Labels loaded successfully with ${labels.length} labels',
    );
  }

  Future<Map<String, double>> inferenceImagePath(String path) async {
    final responsePort = ReceivePort();

    final isolateModel = InferenceModel(
      path,
      null,
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

  Future<Map<String, double>> inferenceImageCamera(CameraImage image) async {
    final responsePort = ReceivePort();

    final isolateModel = InferenceModel(
      null,
      image,
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
