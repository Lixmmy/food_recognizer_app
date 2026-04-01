import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_recognizer_app/controller/image_classification_controller.dart';
import 'package:food_recognizer_app/controller/photo_controller.dart';
import 'package:food_recognizer_app/controller/provider/search_food_provider.dart';
import 'package:food_recognizer_app/firebase_options.dart';
import 'package:food_recognizer_app/pages/picker_page.dart';
import 'package:food_recognizer_app/pages/result_page.dart';
import 'package:food_recognizer_app/router/router.dart';
import 'package:food_recognizer_app/service/api_service.dart';
import 'package:food_recognizer_app/service/firebase_ml_service.dart';
import 'package:food_recognizer_app/service/image_classification_service.dart';
import 'package:food_recognizer_app/service/image_picker_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ImagePickerService()),
        Provider(create: (_) => FirebaseMlService()),
        Provider(create: (_) => ApiService()),
        Provider(
          create: (context) =>
              ImageClassificationService(context.read<FirebaseMlService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchFoodProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageClassificationController(
            context.read<ImageClassificationService>(),
          ),
        ),
        ChangeNotifierProvider<PhotoController>(
          create: (context) =>
              PhotoController(context.read<ImagePickerService>()),
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
        NavigationRoute.resultPage.path: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final classificationResult = args is Map<String, double>
              ? args
              : <String, double>{};
          final imagePath = args is String ? args : '';
          return ResultPage(
            classificationResult: classificationResult,
            imagePath: imagePath,
          );
        },
      },
    );
  }
}
