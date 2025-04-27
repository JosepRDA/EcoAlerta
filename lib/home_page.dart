import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _reportController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
      );
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao selecionar imagem.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitReport() async {
    if (_reportController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, escreva uma denúncia.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _reportController.clear();
      _selectedImage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Denúncia enviada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showTips() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dicas para escrever uma boa denúncia',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('• Descreva o local com detalhes (endereço, ponto de referência).'),
            const Text('• Identifique a espécie, caso reconheça (nome ou características).'),
            const Text('• Informe a natureza do crime (ex: queima de mata, caça ilegal).'),
            const Text('• Inclua data e hora aproximadas do ocorrido.'),
            const Text('• Adicione evidências visuais, se possível (fotos, vídeos).'),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Denúncia'),
        backgroundColor: Colors.green[800],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Ícone de perfil acima do título
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Título com ícone de ajuda
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Registrar denúncia',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.help_outline),
                      color: Colors.green[800],
                      tooltip: 'Dicas de Denúncia',
                      onPressed: _showTips,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Campo de texto
                Expanded(
                  child: TextField(
                    controller: _reportController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Descreva o crime ambiental aqui...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                const SizedBox(height: 20),

                // Preview da imagem, se houver
                if (_selectedImage != null)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_selectedImage!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),

                // Botão de anexar foto
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Adicionar Foto (Opcional)'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green[800]!),
                    foregroundColor: Colors.green[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 20),

                // Botão de enviar denúncia
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Enviar Denúncia',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
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
