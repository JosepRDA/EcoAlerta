import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importa a classe de banco de dados
import 'login_page.dart'; // Redireciona para a tela de login após o registro

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Verifica se as senhas coincidem
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('As senhas não coincidem'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Verifica se o email já está cadastrado
      bool isUserExists = await DatabaseHelper.instance.validateUser(
          _emailController.text, _passwordController.text);

      if (isUserExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este email já está cadastrado'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Registra o novo usuário no banco de dados
        await DatabaseHelper.instance.insertUser(
            _emailController.text, _passwordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro bem-sucedido!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navega para a página de login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * 0.05;

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
                    Image.asset(
                      "assets/images/logo_EcoAlerta.jpeg",
                      width: screenSize.width * 0.5,
                      height: screenSize.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    
                    // Title
                    Text(
                      "EcoAlerta",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 9, 57, 27),
                        fontSize: screenSize.width * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),

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
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Confirmar Senha",
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Por favor confirme sua senha' : null,
                    ),
                    SizedBox(height: screenSize.height * 0.05),

                    // Register Button
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
                          "Registrar",
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
