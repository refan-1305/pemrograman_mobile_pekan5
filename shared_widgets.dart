// -------  Nama Program : Login dan Register -------
//------- Author : Refan Rustoni Putra ------
//------- Versi : 10  ------
//------- Ownership : Pribadi------
//------- Deskripsi : Pembuatan halaman Login, Dashboard dan Profile ------

//------- Library ---------
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

enum AppTab { dashboard, courses, profile }

class BottomNavBar extends StatelessWidget {
  final AppTab activeTab;
  final ValueChanged<AppTab> onTabChange;

  const BottomNavBar({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _TabItem(id: AppTab.dashboard, label: 'DASHBOARD', icon: Icons.grid_view_rounded),
      _TabItem(id: AppTab.courses,   label: 'COURSES',   icon: Icons.menu_book_rounded),
      _TabItem(id: AppTab.profile,   label: 'PROFILE',   icon: Icons.person_rounded),
    ];

    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandPrimary.withOpacity(0.10),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabs
                .map((t) => _NavTabButton(item: t, isActive: activeTab == t.id, onTap: () => onTabChange(t.id)))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final AppTab id;
  final String label;
  final IconData icon;
  const _TabItem({required this.id, required this.label, required this.icon});
}

class _NavTabButton extends StatelessWidget {
  final _TabItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTabButton({required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.brandPrimary.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isActive ? AppColors.brandPrimary : Colors.grey[400],
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isActive ? AppColors.brandPrimary : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── App Header ───────────────────────────────────────────────────────────────

class AppHeader extends StatelessWidget {
  final String subtitle;
  final User user;

  const AppHeader({super.key, required this.subtitle, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        border: Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.brandPrimary.withOpacity(0.2), width: 2),
              color: Colors.grey[100],
              image: DecorationImage(
                image: NetworkImage(
                    'https://api.dicebear.com/7.x/avataaars/svg?seed=${user.nim}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    color: AppColors.brandTextSubtle,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Luminous',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                    color: AppColors.brandPrimary,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    size: 22, color: AppColors.brandPrimary),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Text Field ───────────────────────────────────────────────────────────────

class LuminousTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final bool enabled;
  final Widget? suffix;
  final TextInputType keyboardType;

  const LuminousTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.suffix,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label.toUpperCase(), style: AppTextStyles.label),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          keyboardType: keyboardType,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
            ),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final AttendanceStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dot) = switch (status) {
      AttendanceStatus.hadir      => (const Color(0xFFF0FDF4), AppColors.statusPresent,  AppColors.statusPresent),
      AttendanceStatus.tidakHadir => (const Color(0xFFFEF2F2), AppColors.statusAbsent,   AppColors.statusAbsent),
      AttendanceStatus.online     => (const Color(0xFFEFF6FF), AppColors.statusOnline,    AppColors.statusOnline),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            status.label.toUpperCase(),
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Alert Banner ─────────────────────────────────────────────────────────────

class AlertBanner extends StatelessWidget {
  final String message;
  final bool isError;

  const AlertBanner({super.key, required this.message, this.isError = true});

  @override
  Widget build(BuildContext context) {
    final bg = isError ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4);
    final fg = isError ? const Color(0xFFDC2626)  : const Color(0xFF16A34A);
    final icon = isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fg.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
