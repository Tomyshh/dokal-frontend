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
import '../bloc/forgot_password_cubit.dart';
import '../bloc/forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<ForgotPasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/branding/icononly_transparent_nobuffer.png',
                    height: 56.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: AppSpacing.xxl.h),
                Text(
                  l10n.authForgotPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  l10n.authForgotPasswordSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: AppSpacing.xl.h),
                DokalCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DokalTextField(
                          controller: _email,
                          label: l10n.commonEmail,
                          hint: l10n.commonEmailHint,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_rounded,
                          textInputAction: TextInputAction.done,
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return l10n.commonEmailRequired;
                            if (!value.contains('@')) {
                              return l10n.commonEmailInvalid;
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(context),
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                          listener: (context, state) {
                            if (state.status == ForgotPasswordStatus.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.authForgotPasswordEmailSent,
                                  ),
                                ),
                              );
                            }
                            if (state.status == ForgotPasswordStatus.failure) {
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
                              onPressed: () => _submit(context),
                              isLoading:
                                  state.status == ForgotPasswordStatus.loading,
                              child: Text(l10n.authForgotPasswordSendLink),
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

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ForgotPasswordCubit>().submit(email: _email.text.trim());
  }
}
