import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _tabs = <_Tab>[
    _Tab('/home', Icons.home_rounded, Icons.home_outlined, 'Accueil', false),
    _Tab('/appointments', Icons.calendar_today_rounded, Icons.calendar_today_outlined, 'RDV', false),
    _Tab('/health', Icons.favorite_rounded, Icons.favorite_outline_rounded, 'Santé', false),
    _Tab('/messages', Icons.mail_rounded, Icons.mail_outline_rounded, 'Messages', false),
    _Tab('/account', Icons.person_rounded, Icons.person_outline_rounded, 'Compte', true),
  ];

  int _indexFromLocation(String location) {
    final idx = _tabs.indexWhere((t) => location.startsWith(t.path));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final isSelected = index == currentIndex;
                
                return _NavBarItem(
                  icon: isSelected ? tab.activeIcon : tab.icon,
                  label: tab.label,
                  isSelected: isSelected,
                  hasBadge: tab.hasBadge,
                  onTap: () => context.go(tab.path),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.hasBadge,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool hasBadge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                if (hasBadge)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab {
  const _Tab(this.path, this.activeIcon, this.icon, this.label, this.hasBadge);
  final String path;
  final IconData activeIcon;
  final IconData icon;
  final String label;
  final bool hasBadge;
}
