import 'package:flutter/material.dart';
import 'package:food_recognizer_app/controller/photo_controller.dart';
import 'package:food_recognizer_app/pages/picker_page.dart';
import 'package:food_recognizer_app/router/router.dart';
import 'package:food_recognizer_app/service/image_picker_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ImagePickerService()),
        ChangeNotifierProvider<PhotoController>(
          create: (context) => PhotoController(
            context.read<ImagePickerService>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: NavigationRoute.pickerPage.path,
      routes: {
        NavigationRoute.pickerPage.path: (context) => const PickerPage(),
      },
    );
  }
}
