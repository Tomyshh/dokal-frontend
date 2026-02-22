import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation_preview.dart';
import '../bloc/conversation_cubit.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({
    super.key,
    required this.conversationId,
    this.conversation,
  });

  final String conversationId;
  final ConversationPreview? conversation;

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
    final l10n = context.l10n;
    final conv = widget.conversation;
    return BlocProvider(
      create: (_) =>
          sl<ConversationCubit>(param1: widget.conversationId)..load(),
      child: BlocListener<ConversationCubit, ConversationState>(
        listener: (context, state) {
          if (state.status == ConversationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
        },
        child: Scaffold(
          appBar: DokalAppBar(title: l10n.conversationTitle),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg.w,
                    vertical: AppSpacing.sm.h,
                  ),
                  child: DokalCard(
                    padding: EdgeInsets.all(AppSpacing.md.r),
                    child: Row(
                      children: [
                        _ConversationAvatar(conversation: conv),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                conv?.name ?? l10n.conversationTitle,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                l10n.messagesResponseTime,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        if (conv?.isOnline == true)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(
                                AppRadii.pill.r,
                              ),
                            ),
                            child: Text(
                              l10n.commonOnline,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1.h),
                Expanded(
                  child: BlocBuilder<ConversationCubit, ConversationState>(
                    builder: (context, state) {
                      if (state.status == ConversationStatus.loading ||
                          state.status == ConversationStatus.initial) {
                        return const _ConversationShimmer();
                      }
                      if (state.status == ConversationStatus.failure) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.lg.r),
                            child: Text(
                              state.error ?? l10n.commonError,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      final messages = state.messages;
                      return ListView.builder(
                        padding: EdgeInsets.all(AppSpacing.lg.r),
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
                  padding: EdgeInsets.all(AppSpacing.sm.r),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.outline, width: 1.w),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: l10n.conversationWriteMessageHint,
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md.w,
                              vertical: AppSpacing.sm.h,
                            ),
                          ),
                          onSubmitted: (_) => _send(context),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      SizedBox(
                        width: 36.r,
                        height: 36.r,
                        child: IconButton.filled(
                          onPressed: () => _send(context),
                          icon: Icon(Icons.send_rounded, size: 16.sp),
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

class _ConversationAvatar extends StatelessWidget {
  const _ConversationAvatar({this.conversation});

  final ConversationPreview? conversation;

  @override
  Widget build(BuildContext context) {
    final name = conversation?.name ?? '';
    final color = conversation != null
        ? Color(conversation!.avatarColorValue)
        : AppColors.primary;

    return SizedBox(
      width: 36.r,
      height: 36.r,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          name.isEmpty
              ? '?'
              : name.split(' ').take(2).map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _ConversationShimmer extends StatelessWidget {
  const _ConversationShimmer();

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.surfaceVariant;
    final highlightColor = Colors.white.withValues(alpha: 0.9);
    final block = AppColors.surfaceVariant;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        children: [
          for (var i = 0; i < 6; i++) ...[
            Align(
              alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight,
              child: _ShimmerBubble(
                width: 120.w + (i % 3) * 40.w,
                color: block,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }
}

class _ShimmerBubble extends StatelessWidget {
  const _ShimmerBubble({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 48.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadii.lg.r),
      ),
    );
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
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: m.fromMe
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          border: Border.all(
            color: m.fromMe ? AppColors.primary : AppColors.outline,
            width: 1.w,
          ),
        ),
        child: Text(
          m.text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
