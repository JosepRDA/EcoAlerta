import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool _isLoading = false;

  void _navigateTo(Widget page) {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 238, 217, 1.0),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo_EcoAlerta.jpeg',
                    width: 200,
                  ),
                  const SizedBox(height: 40),

                  // Título
                  Text(
                    'Bem-vindo ao EcoAlerta',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Subtítulo
                  Text(
                    'Ajude-nos a preservar o meio ambiente',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Botão de Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green[800],
                      ),
                      onPressed: () => _navigateTo(const LoginPage()),
                      child: const Text('Fazer Login'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão de Registro
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.green[800]!),
                      ),
                      onPressed: () => _navigateTo(const RegisterPage()),
                      child: Text(
                        'Criar Conta',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}