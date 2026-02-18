import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../../l10n/l10n.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentIndex = navigationShell.currentIndex;

    final tabs = <_Tab>[
      _Tab(0, Icons.home_rounded, Icons.home_outlined, l10n.navHome, false),
      _Tab(
        1,
        Icons.calendar_today_rounded,
        Icons.calendar_today_outlined,
        l10n.navAppointments,
        false,
      ),
      _Tab(
        2,
        Icons.mail_rounded,
        Icons.mail_outline_rounded,
        l10n.navMessages,
        false,
      ),
      _Tab(
        3,
        Icons.person_rounded,
        Icons.person_outline_rounded,
        l10n.navAccount,
        false,
      ),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final isSelected = index == currentIndex;

                return _NavBarItem(
                  icon: isSelected ? tab.activeIcon : tab.icon,
                  label: tab.label,
                  isSelected: isSelected,
                  hasBadge: tab.hasBadge,
                  onTap: () => navigationShell.goBranch(
                    tab.index,
                    // Re-tap on current tab returns to its initial location
                    initialLocation: tab.index == currentIndex,
                  ),
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
        width: 56.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24.sp,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                if (hasBadge)
                  Positioned(
                    right: -8.w,
                    top: -4.h,
                    child: Container(
                      width: 16.w,
                      height: 16.h,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
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
  const _Tab(this.index, this.activeIcon, this.icon, this.label, this.hasBadge);
  final int index;
  final IconData activeIcon;
  final IconData icon;
  final String label;
  final bool hasBadge;
}
