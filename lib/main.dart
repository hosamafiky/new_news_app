import 'package:flutter/material.dart';
import 'package:news_app/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'core/di/dependency_injector.dart';
import 'logic/filter_provider.dart';
import 'logic/tab_index_provider.dart';

void main() {
  setupDependencyInjector();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => TabIndexProvider()),
      ],
      child: const NewsAPIApp(),
    ),
  );
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
