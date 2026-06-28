import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/models.dart';
import '../../providers/user_provider.dart';
import '../../theme/yonwa_theme.dart';

class OnboardingQuestionnaire extends StatefulWidget {
  const OnboardingQuestionnaire({super.key});

  @override
  State<OnboardingQuestionnaire> createState() => _OnboardingQuestionnaireState();
}

class _OnboardingQuestionnaireState extends State<OnboardingQuestionnaire> {
  int _currentStep = 0;
  UserRole? _selectedRole;
  String? _mainInterest;
  final List<String> _selectedRegions = [];
  final List<String> _roleDetails = [];

  final _roles = const [
    _RoleOption(
      role: UserRole.voyageur,
      title: 'Utilisateur standard',
      subtitle: 'Explorer, reserver et suivre vos coups de coeur.',
      icon: Icons.person_rounded,
    ),
    _RoleOption(
      role: UserRole.artisan,
      title: 'Artisan',
      subtitle: 'Presenter votre savoir-faire et vos produits.',
      icon: Icons.brush_rounded,
    ),
    _RoleOption(
      role: UserRole.guideTouristique,
      title: 'Guide touristique',
      subtitle: 'Proposer des experiences et visites locales.',
      icon: Icons.explore_rounded,
    ),
  ];

  final _interests = const [
    'Tourisme',
    'Culture',
    'Aventure',
    'Artisanat',
    'Gastronomie',
  ];

  final _regions = const [
    'Atlantique',
    'Littoral',
    'Oueme',
    'Plateau',
    'Zou',
    'Collines',
    'Donga',
    'Borgou',
    'Atacora',
    'Alibori',
    'Mono',
    'Couffo',
  ];

  List<String> get _detailsOptions {
    switch (_selectedRole) {
      case UserRole.artisan:
        return const ['Textile', 'Poterie', 'Sculpture', 'Bijoux', 'Bois', 'Ateliers'];
      case UserRole.guideTouristique:
        return const ['Histoire', 'Nature', 'Ganvie', 'Ouidah', 'Cuisine locale', 'Circuits prives'];
      case UserRole.voyageur:
      default:
        return const ['Sejour court', 'Famille', 'Solo', 'Budget doux', 'Premium', 'Immersion locale'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.background,
      appBar: AppBar(
        title: const Text('Creer votre profil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(YonwaSpacing.md),
          child: Column(
            children: [
              _buildStepIndicator(),
              const SizedBox(height: YonwaSpacing.xl),
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _buildStep(isDark),
                  ),
                ),
              ),
              const SizedBox(height: YonwaSpacing.md),
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('Retour'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _onContinuePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: YonwaColors.primary500,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_currentStep == 2 ? 'Terminer' : 'Suivant'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index <= _currentStep ? YonwaColors.primary500 : YonwaColors.neutral300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildRoleStep(isDark);
      case 1:
        return _buildPreferencesStep(isDark);
      case 2:
        return _buildRoleDetailsStep(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRoleStep(bool isDark) {
    return Column(
      key: const ValueKey('role'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          title: 'Quel type de profil voulez-vous creer ?',
          subtitle: 'Yonwa adaptera votre profil, vos onglets et vos suggestions.',
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        ..._roles.map((option) {
          final selected = _selectedRole == option.role;
          return _ChoiceCard(
            title: option.title,
            subtitle: option.subtitle,
            icon: option.icon,
            selected: selected,
            isDark: isDark,
            onTap: () => setState(() {
              _selectedRole = option.role;
              _roleDetails.clear();
            }),
          );
        }),
      ],
    );
  }

  Widget _buildPreferencesStep(bool isDark) {
    return Column(
      key: const ValueKey('preferences'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          title: 'Quelles sont vos preferences ?',
          subtitle: 'Choisissez un centre d interet principal et les regions qui comptent.',
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        _SectionLabel('Centre d interet', isDark: isDark),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interests.map((interest) {
            return _Pill(
              label: interest,
              selected: _mainInterest == interest,
              onTap: () => setState(() => _mainInterest = interest),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _SectionLabel('Regions', isDark: isDark),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _regions.map((region) {
            final selected = _selectedRegions.contains(region);
            return _Pill(
              label: region,
              selected: selected,
              onTap: () => setState(() {
                selected ? _selectedRegions.remove(region) : _selectedRegions.add(region);
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoleDetailsStep(bool isDark) {
    final title = switch (_selectedRole) {
      UserRole.artisan => 'Votre savoir-faire',
      UserRole.guideTouristique => 'Vos experiences touristiques',
      _ => 'Votre style de voyage',
    };

    return Column(
      key: const ValueKey('details'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(
          title: title,
          subtitle: 'Ces reponses preparent la structure de votre profil et les futures donnees API.',
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _detailsOptions.map((detail) {
            final selected = _roleDetails.contains(detail);
            return _Pill(
              label: detail,
              selected: selected,
              onTap: () => setState(() {
                selected ? _roleDetails.remove(detail) : _roleDetails.add(detail);
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _onContinuePressed() async {
    if (!_isCurrentStepValid()) return;

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      return;
    }

    final role = _selectedRole ?? UserRole.voyageur;
    await context.read<UserProvider>().completeOnboardingProfile(
          role: role,
          interest: _mainInterest ?? '',
          regions: _selectedRegions,
          details: _roleDetails,
        );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('questionnaire_done', true);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  bool _isCurrentStepValid() {
    if (_currentStep == 0 && _selectedRole == null) {
      _showSelectionError('Choisissez un type de profil');
      return false;
    }
    if (_currentStep == 1 && _mainInterest == null) {
      _showSelectionError('Choisissez un centre d interet');
      return false;
    }
    if (_currentStep == 2 && _roleDetails.isEmpty) {
      _showSelectionError('Selectionnez au moins une option');
      return false;
    }
    return true;
  }

  void _showSelectionError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: YonwaColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.md),
        ),
      ),
    );
  }
}

class _RoleOption {
  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;

  const _RoleOption({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _StepTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;

  const _StepTitle({
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: YonwaTextStyles.h1.copyWith(
            color: isDark ? Colors.white : YonwaColors.neutral800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: YonwaTextStyles.body.copyWith(
            color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral600,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel(this.label, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: YonwaTextStyles.label.copyWith(
        color: isDark ? YonwaColors.neutral200 : YonwaColors.neutral700,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(YonwaRadius.lg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? YonwaColors.primary100
                : (isDark ? YonwaColors.neutral800 : Colors.white),
            borderRadius: BorderRadius.circular(YonwaRadius.lg),
            border: Border.all(
              color: selected ? YonwaColors.primary500 : YonwaColors.neutral200,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: selected ? YonwaColors.primary500 : YonwaColors.neutral100,
                foregroundColor: selected ? Colors.white : YonwaColors.primary500,
                child: Icon(icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: YonwaTextStyles.label.copyWith(
                        color: isDark ? Colors.white : YonwaColors.neutral800,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: YonwaTextStyles.caption.copyWith(
                        color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: YonwaColors.primary500),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      selectedColor: YonwaColors.primary500,
      labelStyle: YonwaTextStyles.label.copyWith(
        color: selected ? Colors.white : YonwaColors.neutral700,
      ),
      side: BorderSide(
        color: selected ? YonwaColors.primary500 : YonwaColors.neutral200,
      ),
      onSelected: (_) => onTap(),
    );
  }
}
