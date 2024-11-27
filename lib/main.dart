import 'package:flutter/material.dart';
import 'screens/Login.dart';

void main() {
  runApp(NutriApp());
}

class NutriApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutri App',
      debugShowCheckedModeBanner: false, // Remove a fita de depuração
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}
