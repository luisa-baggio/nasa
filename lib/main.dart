import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MarsExplorerApp());
}

class MarsExplorerApp extends StatelessWidget {
  const MarsExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mars Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
    );
  }
}
