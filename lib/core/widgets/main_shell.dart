import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../../l10n/l10n.dart';

const _rootPaths = {'/home', '/appointments', '/messages', '/account'};

bool _isRootScreen(String path) {
  final normalized =
      path.endsWith('/') && path.length > 1
          ? path.substring(0, path.length - 1)
          : path;
  return _rootPaths.contains(normalized);
}

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentIndex = navigationShell.currentIndex;

    // GoRouterState.of(context) s'abonne automatiquement aux changements de
    // route et déclenche un rebuild — aucun listener manuel requis.
    final currentPath = GoRouterState.of(context).uri.path;
    final showNavBar = _isRootScreen(currentPath);

    final tabs = <_Tab>[
      _Tab(0, Icons.home_rounded, Icons.home_outlined, l10n.navHome),
      _Tab(
        1,
        Icons.calendar_today_rounded,
        Icons.calendar_today_outlined,
        l10n.navAppointments,
      ),
      _Tab(
        2,
        Icons.mail_rounded,
        Icons.mail_outline_rounded,
        l10n.navMessages,
      ),
      _Tab(
        3,
        Icons.person_rounded,
        Icons.person_outline_rounded,
        l10n.navAccount,
      ),
    ];

    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: showNavBar
          ? Container(
              color: Colors.transparent,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                  child: Container(
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadii.pill.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 24.r,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(tabs.length, (index) {
                      final tab = tabs[index];
                      final isSelected = index == currentIndex;

                      return _NavBarItem(
                        activeIcon: tab.activeIcon,
                        icon: tab.icon,
                        label: tab.label,
                        isSelected: isSelected,
                        onTap: () => navigationShell.goBranch(
                          tab.index,
                          initialLocation: tab.index == currentIndex,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          )
          : null,
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.activeIcon,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData activeIcon;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.w : 12.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.pill.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22.sp,
              color: isSelected
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.65),
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tab {
  const _Tab(this.index, this.activeIcon, this.icon, this.label);
  final int index;
  final IconData activeIcon;
  final IconData icon;
  final String label;
}
