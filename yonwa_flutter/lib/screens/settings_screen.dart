import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SettingsScreen({super.key, required this.onBack});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifPush = true;
  bool _notifEmail = false;
  String _lang = 'Français';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: 'Paramètres', onBack: onBack),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Section(title: 'Apparence', children: [
            _SwitchTile(
              icon: Icons.dark_mode_outlined,
              label: 'Mode sombre',
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
            ),
          ]),
          _Section(title: 'Notifications', children: [
            _SwitchTile(icon: Icons.notifications_outlined, label: 'Notifications push', value: _notifPush, onChanged: (v) => setState(() => _notifPush = v)),
            _SwitchTile(icon: Icons.mail_outline, label: 'Notifications email', value: _notifEmail, onChanged: (v) => setState(() => _notifEmail = v)),
          ]),
          _Section(title: 'Langue & Région', children: [
            _DropdownTile(
              icon: Icons.language,
              label: 'Langue',
              value: _lang,
              options: const ['Français', 'English', 'Deutsch'],
              onChanged: (v) => setState(() => _lang = v!),
            ),
          ]),
          _Section(title: 'Compte', children: [
            _ActionTile(icon: Icons.lock_outline, label: 'Changer le mot de passe', onTap: () {}),
            _ActionTile(icon: Icons.shield_outlined, label: 'Confidentialité', onTap: () {}),
            _ActionTile(icon: Icons.delete_outline, label: 'Supprimer le compte', color: AppColors.primary, onTap: () {}),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1)),
        ),
        Container(
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
          child: Column(children: children),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({required this.icon, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.textDark, size: 18),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
      trailing: Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({required this.icon, required this.label, required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.textDark, size: 18),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
      trailing: DropdownButton<String>(
        value: value,
        items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionTile({required this.icon, required this.label, required this.onTap, this.color = AppColors.textDark});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: color == AppColors.textDark ? AppColors.surface : color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(label, style: TextStyle(fontSize: 14, color: color)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
    );
  }
}
