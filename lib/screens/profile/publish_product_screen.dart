import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class PublishProductScreen extends StatefulWidget {
  const PublishProductScreen({super.key});

  @override
  State<PublishProductScreen> createState() => _PublishProductScreenState();
}

class _PublishProductScreenState extends State<PublishProductScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PublishFormShell(
      title: 'Publier un produit',
      children: [
        _field(_titleController, 'Nom du produit'),
        _field(_priceController, 'Prix', keyboardType: TextInputType.number),
        _field(_stockController, 'Stock disponible', keyboardType: TextInputType.number),
        _field(_imageController, 'URL image'),
        _field(_descriptionController, 'Description', maxLines: 5),
      ],
      submitLabel: 'Publier le produit',
    );
  }
}

class PublishCatalogScreen extends StatefulWidget {
  const PublishCatalogScreen({super.key});

  @override
  State<PublishCatalogScreen> createState() => _PublishCatalogScreenState();
}

class _PublishCatalogScreenState extends State<PublishCatalogScreen> {
  final _nameController = TextEditingController();
  final _countController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PublishFormShell(
      title: 'Creer un catalogue',
      children: [
        _field(_nameController, 'Nom du catalogue'),
        _field(_countController, 'Nombre d elements'),
        _field(_imageController, 'URL image de couverture'),
        _field(_descriptionController, 'Description du catalogue', maxLines: 5),
      ],
      submitLabel: 'Publier le catalogue',
    );
  }
}

class _PublishFormShell extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String submitLabel;

  const _PublishFormShell({
    required this.title,
    required this.children,
    required this.submitLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: YonwaColors.primary500),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...children.expand((child) => [child, const SizedBox(height: 12)]),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title enregistre en mode mock')),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: YonwaColors.primary500,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(submitLabel),
          ),
        ],
      ),
    );
  }
}

Widget _field(
  TextEditingController controller,
  String label, {
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
