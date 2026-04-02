import 'dart:io';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:food_recognizer_app/utils/image_utils.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateInference {
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;
  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: _debugName,
    );
    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);
    await for (final InferenceModel isolateModel in port) {
      final CameraImage? image = isolateModel.image;
      final String? path = isolateModel.path;
      final inputShape = isolateModel.inputShape;

      late List<List<List<num>>> imageMatrix;
      if (path != null) {
        imageMatrix = processUploadImage(path, inputShape);
      } else {
        imageMatrix = processCameraImage(image!, inputShape);
      }

      final input = [imageMatrix];
      final output = [List<int>.filled(isolateModel.outputShape[1], 0)];
      final address = isolateModel.interpreterAddress;

      final result = runInference(address, input, output);

      final double totalScore = result.fold(0.0, (prev, e) => prev + e.toDouble());
      final value = totalScore > 0
          ? result.map((e) => e.toDouble() / totalScore).toList()
          : result.map((e) => e.toDouble()).toList();

      final keys = isolateModel.labels;
      var classification = Map.fromIterables(keys, value);
      classification.removeWhere((key, value) => value == 0);

      isolateModel.responsePort.send(classification);
    }
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

  static List<int> runInference(
    int interpreterAddress,
    List<List<List<List<num>>>> input,
    List<List<int>> output,
  ) {
    final interpreter = Interpreter.fromAddress(interpreterAddress);
    interpreter.run(input, output);
    final result = output.first;
    return result;
  }

  static List<List<List<num>>> processUploadImage(
    String path,
    List<int> inputShape,
  ) {
    final bytes = File(path).readAsBytesSync();
    image_lib.Image image = image_lib.decodeImage(bytes)!;
    image_lib.Image resizedImage = image_lib.copyResize(
      image,
      width: inputShape[1],
      height: inputShape[2],
    );
    if (Platform.isAndroid) {
      resizedImage = image_lib.copyRotate(resizedImage, angle: 90);
    }

    return List.generate(
      resizedImage.height,
      (y) => List.generate(resizedImage.width, (x) {
        final pixel = resizedImage.getPixel(x, y);
        return [pixel.r, pixel.g, pixel.b];
      }),
    );
  }

  static List<List<List<num>>> processCameraImage(
    CameraImage image,
    List<int> inputShape,
  ) {
    image_lib.Image? img;
    img = ImageUtils.convertCameraImage(image);
    image_lib.Image imageInput = image_lib.copyResize(
      img!,
      width: inputShape[1],
      height: inputShape[2],
    );

    if (Platform.isAndroid) {
      imageInput = image_lib.copyRotate(imageInput, angle: 90);
    }
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(imageInput.width, (x) {
        final pixel = imageInput.getPixel(x, y);
        return [pixel.r, pixel.g, pixel.b];
      }),
    );
    return imageMatrix;
  }
}

class InferenceModel {
  String? path;
  CameraImage? image;
  int interpreterAddress;
  List<String> labels;
  List<int> inputShape;
  List<int> outputShape;
  late SendPort responsePort;

  InferenceModel(
    this.path,
    this.image,
    this.interpreterAddress,
    this.labels,
    this.inputShape,
    this.outputShape,
  );
}
