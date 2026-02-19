import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/reset_password_cubit.dart';
import '../bloc/reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _obscure = true;
  bool _confirmObscure = true;

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ResetPasswordCubit>().submit(newPassword: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<ResetPasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/branding/icononly_transparent_nobuffer.png',
                    height: 56.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: AppSpacing.xxl.h),
                Text(
                  l10n.authResetPasswordNewTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  l10n.authResetPasswordNewSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: AppSpacing.xl.h),
                DokalCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DokalTextField(
                          controller: _password,
                          label: l10n.commonPassword,
                          hint: l10n.commonPasswordHint,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.lock_rounded,
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
                            final value = (v ?? '');
                            if (value.isEmpty) {
                              return l10n.commonPasswordRequired;
                            }
                            if (value.length < 6) {
                              return l10n.commonPasswordMinChars(6);
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        DokalTextField(
                          controller: _confirmPassword,
                          label: l10n.authResetPasswordConfirmPassword,
                          hint: l10n.commonPasswordHint,
                          obscureText: _confirmObscure,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_rounded,
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _confirmObscure = !_confirmObscure,
                            ),
                            icon: Icon(
                              _confirmObscure
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                          validator: (v) {
                            final value = (v ?? '');
                            if (value.isEmpty) {
                              return l10n.commonPasswordRequired;
                            }
                            if (value != _password.text) {
                              return l10n.authResetPasswordPasswordsDoNotMatch;
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(context),
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                          listener: (context, state) {
                            if (state.status == ResetPasswordStatus.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(l10n.authResetPasswordUpdatedSnack),
                                ),
                              );
                              context.go('/login');
                            }
                            if (state.status == ResetPasswordStatus.failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    state.errorMessage ?? l10n.commonError,
                                  ),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return DokalButton.primary(
                              onPressed: state.status == ResetPasswordStatus.loading
                                  ? null
                                  : () => _submit(context),
                              isLoading:
                                  state.status == ResetPasswordStatus.loading,
                              child: Text(l10n.authResetPasswordUpdateButton),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(l10n.authBackToLogin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

