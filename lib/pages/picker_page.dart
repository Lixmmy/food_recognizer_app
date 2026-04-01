import 'dart:io';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:food_recognizer_app/controller/image_classification_controller.dart';
import 'package:food_recognizer_app/controller/photo_controller.dart';
import 'package:provider/provider.dart';

class PickerPage extends StatefulWidget {
  const PickerPage({super.key});

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  late final ImageClassificationController classificationController;

  @override
  void initState() {
    super.initState();
    classificationController = context.read<ImageClassificationController>();
    classificationController.initialize();
  }

  Future<void> _cropImage(
    BuildContext context,
    String imagePath,
    PhotoController photoController,
  ) async {
    final imageFile = File(imagePath);
    if (!await imageFile.exists()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File gambar tidak ditemukan untuk crop.'),
          ),
        );
      }
      return;
    }

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        await photoController.updatePhotoPath(croppedFile.path);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Crop dibatalkan.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Crop image error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal crop image: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Food Recognizer App')),
        body: Consumer<PhotoController>(
          builder: (context, photoController, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (photoController.paths != null)
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Image.file(
                          File(photoController.paths!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              photoController.clearPhoto();
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (photoController.previousPaths != null)
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Image.file(
                          File(photoController.previousPaths!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              photoController.clearPhoto();
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else
                  Icon(Icons.photo_library, size: 100),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await photoController.getPhoto(context);
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal memilih gambar dari galeri.'),
                        ),
                      );
                    }
                  },
                  child:
                      photoController.paths != null &&
                          photoController.paths!.isNotEmpty
                      ? const Text('Change Image')
                      : const Text('Pick Image from Gallery'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await photoController.getCameraPhoto(context);
                  },
                  child:
                      photoController.paths != null &&
                          photoController.paths!.isNotEmpty
                      ? const Text('Retake Image')
                      : const Text('Capture Image from Camera'),
                ),
                if (photoController.paths != null &&
                        photoController.paths!.isNotEmpty) ...[
                  ElevatedButton(
                    onPressed: () async {
                      await _cropImage(
                        context,
                        photoController.paths!,
                        photoController,
                      );
                    },
                    child: const Text('Crop Image'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await classificationController.runClassificationByPath(
                        photoController.paths!,
                      );
                      final result =
                          classificationController.classificationResult;
                      final imagePath = photoController.paths!;
                      Navigator.pushNamed(
                        // ignore: use_build_context_synchronously
                        context,
                        '/result_page',
                        arguments: {
                          'result': result,
                          'imagePath': imagePath,
                        },
                      );
                    },
                    child: const Text('Analyze Image'),
                  ),
                ] else
                  SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
