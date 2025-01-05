import 'package:flutter/material.dart';
import 'study_timer_page.dart';
import 'statistics_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: const CardTheme(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StudyTimerPage(),
        '/statistics': (context) => const StatisticsPage(),
      },
    );
  }
}