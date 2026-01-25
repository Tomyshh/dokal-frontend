import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_avatar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/conversation_cubit.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key, required this.conversationId});

  final String conversationId;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ConversationCubit>(param1: widget.conversationId)..load(),
      child: BlocListener<ConversationCubit, ConversationState>(
        listener: (context, state) {
          if (state.status == ConversationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur')),
            );
          }
        },
        child: Scaffold(
          appBar: DokalAppBar(
            title: 'Conversation',
            actions: [
              IconButton(
                tooltip: 'Nouveau message',
                onPressed: () => context.go('/messages/new'),
                icon: const Icon(Icons.edit_rounded, size: 20),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: DokalCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        const DokalAvatar(name: 'Cabinet Benhamou', size: 36),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cabinet Dr BENHAMOU',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Réponse sous 24–48h',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          child: Text(
                            'En ligne',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: BlocBuilder<ConversationCubit, ConversationState>(
                    builder: (context, state) {
                      if (state.status == ConversationStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      final messages = state.messages;
                      return ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final m = messages[index];
                          return _MessageBubble(m: m);
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.outline, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Écrire un message…',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          onSubmitted: (_) => _send(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton.filled(
                          onPressed: () => _send(context),
                          icon: const Icon(Icons.send_rounded, size: 16),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _send(BuildContext ctx) {
    final txt = _controller.text.trim();
    if (txt.isEmpty) return;
    ctx.read<ConversationCubit>().send(txt);
    _controller.clear();
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.m});

  final ChatMessage m;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: m.fromMe
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(
            color: m.fromMe ? AppColors.primary : AppColors.outline,
            width: 1,
          ),
        ),
        child: Text(
          m.text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
      ),
    );
  }
}

