import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class PublishPublicationScreen extends StatefulWidget {
  const PublishPublicationScreen({super.key});

  @override
  State<PublishPublicationScreen> createState() =>
      _PublishPublicationScreenState();
}

class _PublishPublicationScreenState extends State<PublishPublicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier une publication'),
        backgroundColor: YonwaColors.primary500,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(label: 'Titre', controller: _titleController),
              const SizedBox(height: 14),
              _buildField(label: 'Sous-titre', controller: _subtitleController),
              const SizedBox(height: 14),
              _buildField(
                label: 'Texte / Description',
                controller: _contentController,
                maxLines: 6,
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'URL image (optionnel)',
                controller: _imageUrlController,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: YonwaColors.primary500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Publier la publication'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Ce champ est requis' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publication partagée avec succès !')),
      );
      Navigator.of(context).pop();
    }
  }
}
