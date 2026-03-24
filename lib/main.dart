import 'package:flutter/material.dart';
import 'package:food_recognizer_app/pages/picker_page.dart';
import 'package:food_recognizer_app/router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: NavigationRoute.pickerPage.path,
      routes: {
        NavigationRoute.pickerPage.path: (context) => const PickerPage(),
      },
    );
  }
}
