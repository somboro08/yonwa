import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class PublishExperienceScreen extends StatefulWidget {
  const PublishExperienceScreen({super.key});

  @override
  State<PublishExperienceScreen> createState() =>
      _PublishExperienceScreenState();
}

class _PublishExperienceScreenState extends State<PublishExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier une expérience'),
        backgroundColor: YonwaColors.primary500,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(
                label: 'Nom de l’expérience',
                controller: _titleController,
              ),
              const SizedBox(height: 14),
              _buildField(label: 'Lieu', controller: _locationController),
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
                label: 'Description détaillée',
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
                child: const Text('Publier l’expérience'),
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
      context.read<UserProvider>().addExperience({
        'title': _titleController.text,
        'price': '${_priceController.text} FCFA',
        'duration': _durationController.text,
        'description': _descriptionController.text,
        'rating': '5.0 (Nouveau)',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expérience publiée avec succès !')),
      );
      Navigator.of(context).pop();
    }
  }
}
