import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importa a classe de banco de dados
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      bool isValidUser = await DatabaseHelper.instance.validateUser(
          _emailController.text, _passwordController.text);

      if (isValidUser) {
        // Navega para a HomePage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Mostra mensagem de erro se as credenciais estiverem incorretas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciais inválidas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * 0.05;
    final imageSize = screenSize.width * 0.5;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: const Color.fromARGB(255, 9, 57, 27),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color.fromRGBO(246, 238, 217, 1.0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
                    SizedBox(height: screenSize.height * 0.05),
                    Image.asset(
                      "assets/images/logo_EcoAlerta.jpeg",
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    // Título
                    Text(
                      "EcoAlerta",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 9, 57, 27),
                        fontSize: screenSize.width * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 9, 57, 27),
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.mail),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Por favor insira seu email' : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Senha",
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor insira sua senha';
                        }
                        if (value!.length < 6) {
                          return 'Senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
