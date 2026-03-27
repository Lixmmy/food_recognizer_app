import 'dart:io';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_recognizer_app/controller/photo_controller.dart';
import 'package:provider/provider.dart';

class PickerPage extends StatefulWidget {
  const PickerPage({super.key});

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
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
                photoController.paths != null &&
                        photoController.paths!.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () {},
                        child: const Text('Analyze Image'),
                      )
                    : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
