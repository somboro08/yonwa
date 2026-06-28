import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/models.dart';
import '../../providers/user_provider.dart';
import '../../theme/yonwa_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  late final List<TextEditingController> _coverControllers;
  late UserRole _role;
  late final PageController _coverPageController;
  int _currentCoverIndex = 0;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>();
    _nomController = TextEditingController(text: user.nom);
    _prenomController = TextEditingController(text: user.prenom);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.telephone);
    _bioController = TextEditingController(text: user.bio);
    _role = user.role;
    final covers = user.coverImages.isEmpty
        ? [user.coverImage]
        : user.coverImages;
    _coverControllers = covers
        .map((url) => TextEditingController(text: url))
        .toList();
    _coverPageController = PageController();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _coverPageController.dispose();
    for (final controller in _coverControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(_prenomController, 'Prenom', Icons.person_outline_rounded),
          const SizedBox(height: 12),
          _field(_nomController, 'Nom', Icons.badge_outlined),
          const SizedBox(height: 12),
          _field(_emailController, 'Email', Icons.mail_outline_rounded),
          const SizedBox(height: 12),
          _field(_phoneController, 'Telephone', Icons.phone_outlined),
          const SizedBox(height: 12),
          DropdownButtonFormField<UserRole>(
            value: _role,
            decoration: const InputDecoration(
              labelText: 'Type de profil',
              prefixIcon: Icon(Icons.work_outline_rounded),
            ),
            items: UserRole.values
                .map(
                  (role) => DropdownMenuItem(
                    value: role,
                    child: Text(role.displayName),
                  ),
                )
                .toList(),
            onChanged: (role) => setState(() => _role = role ?? _role),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bioController,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Bio',
              prefixIcon: Icon(Icons.notes_rounded),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          Text('Images de couverture', style: YonwaTextStyles.h3),
          const SizedBox(height: 12),
          if (_coverControllers.length > 1)
            Column(
              children: [
                // Carousel for multiple cover images
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _coverPageController,
                        onPageChanged: (index) =>
                            setState(() => _currentCoverIndex = index),
                        itemCount: _coverControllers.length,
                        itemBuilder: (context, index) {
                          final url = _coverControllers[index].text.trim();
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                YonwaRadius.lg,
                              ),
                              child: url.isEmpty
                                  ? Container(
                                      color: isDark
                                          ? YonwaColors.neutral800
                                          : YonwaColors.neutral200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                        ),
                                      ),
                                    )
                                  : Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: isDark
                                            ? YonwaColors.neutral800
                                            : YonwaColors.neutral200,
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      // Carousel indicator
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _coverPageController,
                            count: _coverControllers.length,
                            effect: const ScrollingDotsEffect(
                              dotWidth: 8,
                              dotHeight: 8,
                              activeDotColor: YonwaColors.primary500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            )
          else if (_coverControllers.isNotEmpty)
            Column(
              children: [
                // Single cover image preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(YonwaRadius.lg),
                  child: _coverControllers[0].text.trim().isEmpty
                      ? Container(
                          height: 200,
                          color: isDark
                              ? YonwaColors.neutral800
                              : YonwaColors.neutral200,
                          child: const Center(
                            child: Icon(Icons.image_outlined, size: 48),
                          ),
                        )
                      : Image.network(
                          _coverControllers[0].text.trim(),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 200,
                            color: isDark
                                ? YonwaColors.neutral800
                                : YonwaColors.neutral200,
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          const SizedBox(height: 8),
          ..._coverControllers.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: 'URL couverture ${entry.key + 1}',
                  prefixIcon: const Icon(Icons.image_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    onPressed: _coverControllers.length == 1
                        ? null
                        : () => setState(
                            () => _coverControllers.removeAt(entry.key),
                          ),
                  ),
                ),
              ),
            );
          }),
          OutlinedButton.icon(
            onPressed: () =>
                setState(() => _coverControllers.add(TextEditingController())),
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Ajouter une couverture'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: YonwaColors.primary500,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }

  Future<void> _save() async {
    await context.read<UserProvider>().updateEditableProfile(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      email: _emailController.text.trim(),
      telephone: _phoneController.text.trim(),
      role: _role,
      bio: _bioController.text.trim(),
      coverImages: _coverControllers.map((c) => c.text.trim()).toList(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil mis a jour')));
    Navigator.pop(context);
  }
}
