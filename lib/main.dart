import 'package:flutter/material.dart';
import 'package:eco_alerta_app/home_page.dart';
import 'package:eco_alerta_app/initial_page.dart';
import 'package:eco_alerta_app/register_page.dart';
import 'package:eco_alerta_app/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAlerta',
      debugShowCheckedModeBanner: false, // removes the debug symbol
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: InitialPage(),
    );
  }
}
