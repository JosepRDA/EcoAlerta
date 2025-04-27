import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('profile_image');
      _bioController.text = prefs.getString('profile_bio') ?? '';
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _imagePath = image.path);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', _imagePath ?? '');
    await prefs.setString('profile_bio', _bioController.text.trim());
    await Future.delayed(const Duration(seconds: 1)); // para feedback
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil salvo com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Perfil'),
        backgroundColor: Colors.green[800],
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imagePath != null && _imagePath!.isNotEmpty
                        ? FileImage(File(_imagePath!)) as ImageProvider
                        : null,
                    child: _imagePath == null || _imagePath!.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text('Alterar Foto de Perfil'),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Escreva algo sobre você...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Salvar Perfil',
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
