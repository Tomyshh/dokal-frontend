import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
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
      _Tab(0, FontAwesomeIcons.house, FontAwesomeIcons.house, l10n.navHome),
      _Tab(
        1,
        FontAwesomeIcons.calendarDays,
        FontAwesomeIcons.calendarDays,
        l10n.navAppointments,
      ),
      _Tab(
        2,
        FontAwesomeIcons.envelope,
        FontAwesomeIcons.envelope,
        l10n.navMessages,
      ),
      _Tab(
        3,
        FontAwesomeIcons.user,
        FontAwesomeIcons.user,
        l10n.navAccount,
      ),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: showNavBar
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (index) => navigationShell.goBranch(
                    index,
                    initialLocation: index == currentIndex,
                  ),
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: AppColors.textSecondary,
                  selectedFontSize: 12.sp,
                  unselectedFontSize: 12.sp,
                  iconSize: 24.sp,
                  elevation: 0,
                  items: tabs
                      .map(
                        (tab) => BottomNavigationBarItem(
                          icon: FaIcon(tab.icon, size: 22.sp),
                          activeIcon: FaIcon(tab.activeIcon, size: 22.sp),
                          label: tab.label,
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          : null,
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
