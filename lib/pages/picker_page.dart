import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickerPage extends StatefulWidget {
  const PickerPage({super.key});

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Food Recognizer App')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Image.file(File(image!.path), fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : Icon(Icons.photo_library, size: 100),
            ElevatedButton(
              onPressed: () async {
                XFile? pickedImage = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedImage != null) {
                  setState(() {
                    image = pickedImage;
                  });
                }
              },
              child: image != null
                  ? const Text('Change Image')
                  : const Text('Pick Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: () async {
                XFile? capturedImage = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (capturedImage != null) {
                  setState(() {
                    image = XFile(capturedImage.path);
                  });
                }
              },
              child: image != null
                  ? const Text('Retake Image')
                  : const Text('Capture Image from Camera'),
            ),
            image != null
                ? ElevatedButton(
                    onPressed: () {},
                    child: const Text('Analyze Image'),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
