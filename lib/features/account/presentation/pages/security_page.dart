import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_list_tile.dart';
import '../../../../core/widgets/logout_overlay.dart';
import '../../../../l10n/l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/utils/logout_confirm_dialog.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => curr.status == AuthStatus.unauthenticated,
      listener: (context, state) {
        context.go('/account');
      },
      child: Scaffold(
        appBar: DokalAppBar(title: l10n.securityTitle),
        body: Stack(
          children: [
            SafeArea(
              child: ListView(
                padding: EdgeInsets.all(AppSpacing.lg.r),
                children: [
                  DokalCard(
                    padding: EdgeInsets.all(AppSpacing.md.r),
                    child: Row(
                      children: [
                        Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.shield_rounded,
                            size: 18.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.securitySecureAccountTitle,
                                style: AppTextStyles.titleSm(),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                l10n.securitySecureAccountSubtitle,
                                style: AppTextStyles.bodySm(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  DokalListTile(
                    icon: Icons.lock_rounded,
                    title: l10n.securityChangePassword,
                    onTap: () => context.go('/account/security/change-password'),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  DokalButton.outline(
                    onPressed: () => showLogoutConfirmDialog(context),
                    leading: Icon(Icons.logout_rounded, size: 18.sp),
                    child: Text(l10n.authLogout),
                  ),
                ],
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (prev, curr) => prev.status != curr.status,
              builder: (context, state) {
                if (state.status != AuthStatus.loggingOut) {
                  return const SizedBox.shrink();
                }
                return LogoutOverlay(message: l10n.authLoggingOut);
              },
            ),
          ],
        ),
      ),
    );
  }
}
