import 'package:flutter/material.dart';
import 'package:weather/models/city.dart';
import 'package:weather/ui/get_started.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Weather Application",
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            scaffoldBackgroundColor: Colors.white),
        showSemanticsDebugger: false,
        home: const GetStarted());
  }
}
