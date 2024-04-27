import 'package:flutter/material.dart';
import 'package:todo_sqlite/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo App",
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black)),
      home: const HomeScreen(),
    );
  }
}
