import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final AppButtonVariant variant;
  final bool small;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.fullWidth = false,
    this.variant = AppButtonVariant.primary,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    Border? border;

    switch (variant) {
      case AppButtonVariant.primary:
        bgColor = AppColors.primary;
        fgColor = Colors.white;
        break;
      case AppButtonVariant.secondary:
        bgColor = AppColors.surface;
        fgColor = AppColors.textDark;
        break;
      case AppButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = AppColors.primary;
        break;
      case AppButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = AppColors.primary;
        border = Border.all(color: AppColors.primary, width: 1.5);
        break;
    }

    final content = SizedBox(
      width: fullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          padding: small
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: border != null
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: AppColors.primary, width: 1.5),
                )
              : const StadiumBorder(),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: small ? 13 : 14,
          ),
        ),
        child: Text(label),
      ),
    );

    return content;
  }
}

enum AppButtonVariant { primary, secondary, ghost, outline }

class StarRating extends StatelessWidget {
  final double value;
  final int? count;
  final double size;

  const StarRating({super.key, required this.value, this.count, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: AppColors.secondary),
        const SizedBox(width: 3),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 2),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: size - 1,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

class AppBadge extends StatelessWidget {
  final String label;
  final Color color;

  const AppBadge({super.key, required this.label, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class NetworkImg extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const NetworkImg({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => Container(color: AppColors.surface),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.surface,
        child: const Icon(Icons.image_outlined, color: AppColors.textLight),
      ),
    );
  }
}

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;
  final Widget? action;

  const AppTopBar({super.key, this.title, this.onBack, this.action});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: onBack != null
          ? IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left, color: AppColors.textDark, size: 26),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            )
          : null,
      actions: action != null ? [action!, const SizedBox(width: 8)] : null,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: "Accueil", active: currentIndex == 0, onTap: () => onTap(0)),
              _NavItem(icon: Icons.explore_rounded, label: "Explorer", active: currentIndex == 1, onTap: () => onTap(1)),
              _NavItem(icon: Icons.calendar_month_rounded, label: "Réservations", active: currentIndex == 2, onTap: () => onTap(2)),
              _NavItem(icon: Icons.chat_bubble_rounded, label: "Messages", active: currentIndex == 3, onTap: () => onTap(3)),
              _NavItem(icon: Icons.person_rounded, label: "Profil", active: currentIndex == 4, onTap: () => onTap(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 9.5, color: color, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionTitle({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
