import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/conversation_preview.dart';
import '../bloc/messages_cubit.dart';

class MessagesListPage extends StatelessWidget {
  const MessagesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MessagesCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 48,
          centerTitle: true,
          title: Text(
            'Messages',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
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
                            leading: const Icon(Icons.done_all_rounded, size: 20),
                            title: Text(
                              'Marquer tout comme lu',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Fonction disponible bientôt')),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.tune_rounded, size: 20),
                            title: Text(
                              'Paramètres',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              context.go('/account/settings');
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
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
                title: 'Impossible de charger',
                subtitle: state.error ?? 'Réessayez dans un instant.',
                icon: Icons.error_outline_rounded,
              );
            }
            if (conversations.isEmpty) {
              return const DokalEmptyState(
                title: 'Vos messages',
                subtitle:
                    'Démarrez une conversation avec vos praticiens pour demander un document, '
                    'poser une question ou suivre vos résultats.',
                icon: Icons.mail_rounded,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                return _ConversationTile(
                  conversation: conv,
                  onTap: () => context.go('/messages/c/${conv.id}'),
                  showDivider: index < conversations.length - 1,
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () => context.go('/messages/new'),
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(
                    name: conversation.name,
                    color: Color(conversation.avatarColorValue),
                    isOnline: conversation.isOnline,
                  ),
                  const SizedBox(width: AppSpacing.md),
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
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                conversation.lastMessage,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: conversation.unreadCount > 0
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (conversation.unreadCount > 0) ...[
                              const SizedBox(width: AppSpacing.xs),
                              _UnreadBadge(count: conversation.unreadCount),
                            ],
                          ],
                        ),
                        if (conversation.appointment != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          _AppointmentChip(appointment: conversation.appointment!),
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
                indent: 64,
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
      width: 40,
      height: 40,
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 13,
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
                width: 10,
                height: 10,
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
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 11,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                appointment.date,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontSize: 9,
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
