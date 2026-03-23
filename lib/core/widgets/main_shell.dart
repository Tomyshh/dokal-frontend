import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_shadows.dart';
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

    final currentPath = GoRouterState.of(context).uri.path;
    final showNavBar = _isRootScreen(currentPath);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: showNavBar
          ? Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppShadows.navbar,
              ),
              child: SafeArea(
                top: false,
                child: NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) => navigationShell.goBranch(
                    index,
                    initialLocation: index == currentIndex,
                  ),
                  destinations: [
                    NavigationDestination(
                      icon: FaIcon(FontAwesomeIcons.house, size: 20.sp),
                      selectedIcon: FaIcon(FontAwesomeIcons.house, size: 20.sp),
                      label: l10n.navHome,
                    ),
                    NavigationDestination(
                      icon: FaIcon(FontAwesomeIcons.calendarDays, size: 20.sp),
                      selectedIcon: FaIcon(FontAwesomeIcons.calendarDays, size: 20.sp),
                      label: l10n.navAppointments,
                    ),
                    NavigationDestination(
                      icon: FaIcon(FontAwesomeIcons.envelope, size: 20.sp),
                      selectedIcon: FaIcon(FontAwesomeIcons.envelope, size: 20.sp),
                      label: l10n.navMessages,
                    ),
                    NavigationDestination(
                      icon: FaIcon(FontAwesomeIcons.user, size: 20.sp),
                      selectedIcon: FaIcon(FontAwesomeIcons.user, size: 20.sp),
                      label: l10n.navAccount,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
