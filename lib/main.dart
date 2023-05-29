import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(
    MaterialApp(
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
