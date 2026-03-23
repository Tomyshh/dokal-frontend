import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_animations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/format_appointment_date.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_badge.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_fade_in.dart';
import '../../../../core/widgets/dokal_shimmer_block.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/conversation_preview.dart';
import '../bloc/messages_cubit.dart';

class MessagesListPage extends StatelessWidget {
  const MessagesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasSession = Supabase.instance.client.auth.currentSession != null;
    return BlocProvider(
      create: (_) => sl<MessagesCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: DokalAppBar(
          title: l10n.messagesTitle,
          showBackButton: false,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (ctx) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.done_all_rounded,
                              size: 20.sp,
                            ),
                            title: Text(
                              l10n.messagesMarkAllRead,
                              style: AppTextStyles.titleSm(),
                            ),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.commonAvailableSoon),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.tune_rounded, size: 20.sp),
                            title: Text(
                              l10n.commonSettings,
                              style: AppTextStyles.titleSm(),
                            ),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              context.push('/account/settings');
                            },
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.more_vert, size: 20.sp),
            ),
          ],
        ),
        body: BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            final conversations = state.conversations;
            if (state.status == MessagesStatus.loading) {
              return const _MessagesListShimmer();
            }
            if (state.status == MessagesStatus.failure) {
              return DokalEmptyState(
                title: l10n.commonUnableToLoad,
                subtitle: state.error ?? l10n.commonTryAgainInAMoment,
                icon: Icons.error_outline_rounded,
              );
            }
            if (conversations.isEmpty) {
              return DokalEmptyState(
                title: l10n.messagesEmptyTitle,
                subtitle: hasSession
                    ? l10n.messagesEmptySubtitle
                    : '${l10n.messagesEmptySubtitle}\n${l10n.authLoginSubtitle}',
                icon: Icons.mail_rounded,
                action: hasSession
                    ? null
                    : DokalButton.gold(
                        onPressed: () => context.go('/account'),
                        leading: const Icon(Icons.login_rounded),
                        child: Text(l10n.authLoginButton),
                      ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(
                top: AppSpacing.sm.h,
                bottom: 100.h,
              ),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                return DokalFadeIn(
                  delay: AppAnimations.staggerDelayFor(index),
                  child: _ConversationTile(
                    conversation: conv,
                    onTap: () =>
                        context.push('/messages/c/${conv.id}', extra: conv),
                    showDivider: index < conversations.length - 1,
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_messages',
          onPressed: () => hasSession
              ? context.push('/messages/new')
              : context.go('/account'),
          child: Icon(Icons.edit_rounded, size: 22.sp),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHIMMER
// ═══════════════════════════════════════════════════════════════════════════════

class _MessagesListShimmer extends StatelessWidget {
  const _MessagesListShimmer();

  @override
  Widget build(BuildContext context) {
    return DokalShimmerGroup(
      child: ListView(
        padding: EdgeInsets.only(top: AppSpacing.sm.h, bottom: 100.h),
        children: [
          for (var i = 0; i < 5; i++) ...[
            _ShimmerTile(),
            if (i < 4)
              Divider(
                height: 1.h,
                thickness: 1.r,
                indent: 64.w,
                color: AppColors.outline.withValues(alpha: 0.5),
              ),
          ],
        ],
      ),
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.sm.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DokalShimmerBlock.circle(size: 40.r),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: DokalShimmerBlock(height: 14.h)),
                    SizedBox(width: AppSpacing.sm.w),
                    DokalShimmerBlock(
                      height: 12.h,
                      width: 40.w,
                      borderRadius: AppRadii.pill,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                DokalShimmerBlock(height: 12.h, width: 180.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONVERSATION TILE
// ═══════════════════════════════════════════════════════════════════════════════

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.onTap,
    this.showDivider = true,
  });

  final ConversationPreview conversation;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppColors.surface,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg.w,
                vertical: AppSpacing.sm.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(
                    name: conversation.name,
                    avatarUrl: conversation.avatarUrl,
                    color: Color(conversation.avatarColorValue),
                    isOnline: conversation.isOnline,
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                conversation.name,
                                style: AppTextStyles.titleSm(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              conversation.timeAgo,
                              style: AppTextStyles.labelXs(
                                color: conversation.unreadCount > 0
                                    ? AppColors.primary
                                    : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                conversation.lastMessage,
                                style: AppTextStyles.bodyXs(
                                  color: conversation.unreadCount > 0
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ).copyWith(
                                  fontWeight: conversation.unreadCount > 0
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (conversation.unreadCount > 0) ...[
                              SizedBox(width: AppSpacing.xs.w),
                              DokalBadge(count: conversation.unreadCount),
                            ],
                          ],
                        ),
                        if (conversation.appointment != null) ...[
                          SizedBox(height: AppSpacing.xs.h),
                          _AppointmentChip(
                            appointment: conversation.appointment!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showDivider)
              Divider(
                height: 1.h,
                thickness: 1.r,
                indent: 64.w,
                color: AppColors.outline.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// AVATAR
// ═══════════════════════════════════════════════════════════════════════════════

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.color,
    required this.isOnline,
    this.avatarUrl,
  });

  final String name;
  final String? avatarUrl;
  final Color color;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .take(2)
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join()
        .toUpperCase();
    final displayInitials = initials.isEmpty ? '?' : initials;

    return SizedBox(
      width: 40.r,
      height: 40.r,
      child: Stack(
        children: [
          ClipOval(
            child: (avatarUrl?.trim().isNotEmpty ?? false)
                ? CachedNetworkImage(
                    imageUrl: avatarUrl!,
                    width: 40.r,
                    height: 40.r,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _buildInitialsPlaceholder(displayInitials),
                    errorWidget: (context, url, error) =>
                        _buildInitialsPlaceholder(displayInitials),
                  )
                : _buildInitialsPlaceholder(displayInitials),
          ),
          if (isOnline)
            Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5.w),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInitialsPlaceholder(String initials) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.labelMd(color: color),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APPOINTMENT CHIP
// ═══════════════════════════════════════════════════════════════════════════════

class _AppointmentChip extends StatelessWidget {
  const _AppointmentChip({required this.appointment});

  final ConversationAppointmentPreview appointment;

  String _statusLabel(AppLocalizations l10n) {
    switch (appointment.status) {
      case 'pending':
        return l10n.practitionerAppointmentStatusPending;
      case 'confirmed':
        return l10n.practitionerAppointmentStatusConfirmed;
      case 'completed':
        return l10n.practitionerAppointmentStatusCompleted;
      case 'cancelled_by_patient':
      case 'cancelled_by_practitioner':
        return l10n.practitionerAppointmentStatusCancelled;
      case 'no_show':
        return l10n.practitionerAppointmentStatusNoShow;
      default:
        return appointment.status.isNotEmpty ? appointment.status : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final statusLabel = _statusLabel(l10n);
    final formattedDate =
        formatAppointmentDateShort(context, appointment.date);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.xs.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22.r,
            height: 22.r,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              size: 11.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.xs.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statusLabel,
                style: AppTextStyles.labelXs(color: AppColors.textPrimary),
              ),
              Text(
                formattedDate,
                style: AppTextStyles.labelXs(color: AppColors.primary)
                    .copyWith(fontSize: 9.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
