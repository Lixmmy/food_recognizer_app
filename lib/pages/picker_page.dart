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
                if (photoController.paths != null &&
                    photoController.paths!.isNotEmpty)
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Image.file(
                          File(photoController.paths!.first),
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
                    photoController.getPhoto(context);
                  },
                  child:
                      photoController.paths != null &&
                          photoController.paths!.isNotEmpty
                      ? const Text('Change Image')
                      : const Text('Pick Image from Gallery'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    
                  },
                  child: photoController.paths != null && photoController.paths!.isNotEmpty
                      ? const Text('Retake Image')
                      : const Text('Capture Image from Camera'),
                ),
                photoController.paths != null &&
                        photoController.paths!.isNotEmpty
                    ? Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Analyze Image'),
                          ),
                          if (photoController.previousPaths != null &&
                              photoController.previousPaths!.isNotEmpty)
                            ElevatedButton(
                              onPressed: () {
                                photoController.restorePreviousPhoto();
                              },
                              child: const Text('Restore Previous Image'),
                            ),
                        ],
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
