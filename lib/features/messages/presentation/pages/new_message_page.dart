import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../l10n/l10n.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({super.key, this.initialSubject, this.initialMessage});

  final String? initialSubject;
  final String? initialMessage;

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subject.text = (widget.initialSubject ?? '').trim();
    _message.text = (widget.initialMessage ?? '').trim();
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: DokalAppBar(title: l10n.messagesNewMessageTitle),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.messagesWriteToOfficeTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                l10n.messagesResponseTime,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: AppSpacing.md.h),
              Expanded(
                child: DokalCard(
                  padding: EdgeInsets.all(AppSpacing.md.r),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DokalTextField(
                          controller: _subject,
                          label: l10n.messagesSubjectLabel,
                          hint: l10n.messagesSubjectHint,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.subject_rounded,
                          validator: (v) => (v ?? '').trim().isEmpty
                              ? l10n.messagesSubjectRequired
                              : null,
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        Expanded(
                          child: TextFormField(
                            controller: _message,
                            maxLines: null,
                            expands: true,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              labelText: l10n.messagesMessageLabel,
                              hintText: l10n.messagesMessageHint,
                              alignLabelWithHint: true,
                              prefixIcon: Icon(
                                Icons.chat_bubble_rounded,
                                size: 18.sp,
                              ),
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                            validator: (v) => (v ?? '').trim().length < 10
                                ? l10n.commonMinChars(10)
                                : null,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        DokalButton.primary(
                          onPressed: () {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                            context.go('/messages/c/demo1');
                          },
                          leading: const Icon(Icons.send_rounded),
                          child: Text(l10n.messagesSendButton),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
