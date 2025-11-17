import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const NewsAPIApp());
}

class NewsAPIApp extends StatelessWidget {
  const NewsAPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: const Color(0xFFF9FAFB), fontFamily: 'SF Pro Display'),
      home: const HomeScreen(),
    );
  }
}
