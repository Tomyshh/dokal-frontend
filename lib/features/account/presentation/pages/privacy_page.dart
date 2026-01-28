import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../l10n/l10n.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: DokalAppBar(title: l10n.privacyTitle),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          children: [
            _PrivacyTile(
              icon: Icons.security_rounded,
              title: l10n.privacyYourDataTitle,
              subtitle: l10n.privacyYourDataSubtitle,
            ),
            SizedBox(height: AppSpacing.sm.h),
            _PrivacyTile(
              icon: Icons.share_rounded,
              title: l10n.privacySharingTitle,
              subtitle: l10n.privacySharingSubtitle,
            ),
            SizedBox(height: AppSpacing.sm.h),
            _PrivacyTile(
              icon: Icons.download_rounded,
              title: l10n.privacyExportTitle,
              subtitle: l10n.privacyExportSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  const _PrivacyTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.primary),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 2.h),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
