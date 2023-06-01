import 'package:flutter/material.dart';

import 'dio.dart';
import 'home.dart';

bool isDarkTheme(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Future<void> main() async {
  await initDioClient();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeoTrickBD',
      home: const Home(),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
    ),
  );
}
