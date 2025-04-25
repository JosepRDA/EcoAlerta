import 'package:flutter/material.dart';

// gonna leave it like this for now
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text("Página inicial!"),
      ),
      body: const Center(
        child: Text("Bem vindo!"),)
    );
  }
}