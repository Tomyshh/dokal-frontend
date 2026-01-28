import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/dokal_button.dart';
import '../../../../../core/widgets/dokal_card.dart';
import '../../../../../core/widgets/dokal_text_field.dart';
import '../../../../../injection_container.dart';
import '../../../../../l10n/l10n.dart';
import '../../bloc/change_password_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<ChangePasswordCubit>(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
          if (state.status == ChangePasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.securityChangePasswordSuccess)),
            );
            if (context.canPop()) context.pop();
            context.go('/account/security');
          }
        },
        builder: (context, state) {
          final isLoading = state.status == ChangePasswordStatus.loading;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.securityChangePassword)),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl.r),
                child: DokalCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DokalTextField(
                          controller: _current,
                          label: l10n.securityCurrentPassword,
                          hint: l10n.commonPasswordHint,
                          obscureText: _obscure,
                          prefixIcon: Icons.lock_rounded,
                          validator: (v) =>
                              (v ?? '').isEmpty ? l10n.commonRequired : null,
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        DokalTextField(
                          controller: _next,
                          label: l10n.securityNewPassword,
                          hint: l10n.commonPasswordHint,
                          obscureText: _obscure,
                          prefixIcon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                          validator: (v) {
                            final value = v ?? '';
                            if (value.isEmpty) return l10n.commonRequired;
                            if (value.length < 6) {
                              return l10n.commonPasswordMinChars(6);
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        DokalButton.primary(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  context.read<ChangePasswordCubit>().submit();
                                },
                          isLoading: isLoading,
                          child: Text(l10n.commonContinue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
