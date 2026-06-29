import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class PublishServiceScreen extends StatefulWidget {
  const PublishServiceScreen({super.key});

  @override
  State<PublishServiceScreen> createState() => _PublishServiceScreenState();
}

class _PublishServiceScreenState extends State<PublishServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier un service'),
        backgroundColor: YonwaColors.primary500,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(
                label: 'Titre du service',
                controller: _titleController,
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Prix',
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              _buildField(label: 'Durée', controller: _durationController),
              const SizedBox(height: 14),
              _buildField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 6,
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
                child: const Text('Publier le service'),
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
      context.read<UserProvider>().addService({
        'title': _titleController.text,
        'price': '${_priceController.text} FCFA',
        'duration': _durationController.text,
        'description': _descriptionController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service publié avec succès !')),
      );
      Navigator.of(context).pop();
    }
  }
}
