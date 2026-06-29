import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../providers/user_provider.dart';
import '../../models/models.dart';

/// Avatar cliquable de l'utilisateur courant → ouvre le profil self (/me).
/// Utilisé dans la sidebar web, le drawer, etc.
class ProfileAvatar extends ConsumerWidget {
  final double radius;
  final bool showLabel; // affiche "Mon Profil" sous-jacent (sidebar)
  final bool compact; // mode icône seule (sidebar tablet)

  const ProfileAvatar({
    super.key,
    this.radius = 18,
    this.showLabel = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProviderRef);

    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: IconButton(
          onPressed: () => context.go('/me'),
          icon: CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(user.photoUrl),
            backgroundColor: const Color(0xFFF2F2F4),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => context.go('/me'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: radius,
              backgroundImage: NetworkImage(user.photoUrl),
              backgroundColor: const Color(0xFFF2F2F4),
            ),
            if (showLabel) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            user.fullName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D0D0D),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedTickDouble02,
                          color: Color(0xFF38A169),
                          size: 14,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.role.displayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B6B7A),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB0B0BE),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
