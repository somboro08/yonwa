import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class WriteAdventureScreen extends StatefulWidget {
  const WriteAdventureScreen({super.key});

  @override
  State<WriteAdventureScreen> createState() => _WriteAdventureScreenState();
}

class _WriteAdventureScreenState extends State<WriteAdventureScreen> {
  final _titleController = TextEditingController();
  final _placeController = TextEditingController();
  final _coverController = TextEditingController();
  final _peopleController = TextEditingController();
  final _mediaController = TextEditingController();
  final _storyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _coverController.dispose();
    _peopleController.dispose();
    _mediaController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecrire une aventure'),
        backgroundColor: YonwaColors.primary500,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(_titleController, 'Titre de l aventure'),
          const SizedBox(height: 12),
          _field(_placeController, 'Lieu visite'),
          const SizedBox(height: 12),
          _field(_coverController, 'URL image de couverture'),
          const SizedBox(height: 12),
          _field(_peopleController, 'Noms des touristes guides'),
          const SizedBox(height: 12),
          _field(_mediaController, 'URLs images/videos separees par des virgules'),
          const SizedBox(height: 12),
          _field(_storyController, 'Narration de l aventure', maxLines: 8),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aventure publiee en mode mock')),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: YonwaColors.primary500,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Publier l aventure'),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
