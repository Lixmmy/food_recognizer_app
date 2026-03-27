import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_recognizer_app/main.dart';
import 'package:provider/provider.dart';
import 'package:food_recognizer_app/controller/photo_controller.dart';
import 'package:food_recognizer_app/service/image_picker_service.dart';

void main() {
  testWidgets('Picker page loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider(create: (_) => ImagePickerService()),
          ChangeNotifierProvider(
            create: (context) => PhotoController(context.read<ImagePickerService>()),
          ),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the app bar title is present
    expect(find.text('Food Recognizer App'), findsOneWidget);

    // Verify that the pick image button is present
    expect(find.text('Pick Image from Gallery'), findsOneWidget);
  });
}
