import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../injection_container.dart';
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
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 48.h,
          centerTitle: true,
          title: Text(
            l10n.messagesTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
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
                            leading: const Icon(
                              Icons.done_all_rounded,
                              size: 20,
                            ),
                            title: Text(
                              l10n.messagesMarkAllRead,
                              style: Theme.of(context).textTheme.titleSmall,
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
                            leading: const Icon(Icons.tune_rounded, size: 20),
                            title: Text(
                              l10n.commonSettings,
                              style: Theme.of(context).textTheme.titleSmall,
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
              icon: const Icon(Icons.more_vert, size: 20),
            ),
          ],
        ),
        body: BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            final conversations = state.conversations;
            if (state.status == MessagesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
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
                    : ElevatedButton(
                        onPressed: () => context.push('/account'),
                        child: Text(l10n.authLoginButton),
                      ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(top: AppSpacing.sm.h),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                return _ConversationTile(
                  conversation: conv,
                  onTap: () => context.push('/messages/c/${conv.id}'),
                  showDivider: index < conversations.length - 1,
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.small(
          heroTag: 'fab_messages',
          onPressed: () => hasSession
              ? context.push('/messages/new')
              : context.push('/account'),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

/// Tile de conversation
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
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              conversation.timeAgo,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: conversation.unreadCount > 0
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: conversation.unreadCount > 0
                                        ? FontWeight.w600
                                        : FontWeight.w400,
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
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
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
                              _UnreadBadge(count: conversation.unreadCount),
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
                height: 1,
                thickness: 1,
                indent: 64.w,
                color: AppColors.outline.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}

/// Avatar avec indicateur en ligne
class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.color,
    required this.isOnline,
  });

  final String name;
  final Color color;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').take(2).map((e) => e[0]).join();

    return SizedBox(
      width: 40.r,
      height: 40.r,
      child: Stack(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ),
          if (isOnline)
            Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Badge de messages non lus
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Chip d'aperçu RDV
class _AppointmentChip extends StatelessWidget {
  const _AppointmentChip({required this.appointment});

  final ConversationAppointmentPreview appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22.r,
            height: 22.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
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
                appointment.title,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                appointment.date,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
