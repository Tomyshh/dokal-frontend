import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/dokal_button.dart';
import '../../../../../core/widgets/dokal_card.dart';
import '../../../../../core/widgets/dokal_text_field.dart';
import '../../../../../injection_container.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/l10n.dart';
import '../../bloc/change_password_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _obscure = true;
  bool _confirmObscure = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<ChangePasswordCubit>();
      if (cubit.state.step == ChangePasswordStep.sendOtp &&
          cubit.state.status == ChangePasswordStatus.initial) {
        cubit.sendOtp();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _password.dispose();
    _confirmPassword.dispose();
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
            context.go('/login');
          }
          if (state.status == ChangePasswordStatus.initial &&
              state.step == ChangePasswordStep.enterOtp) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.authForgotPasswordEmailSent)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == ChangePasswordStatus.loading;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.securityChangePassword)),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl.r),
                child: _buildStepContent(context, state, isLoading, l10n),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    ChangePasswordState state,
    bool isLoading,
    AppLocalizations l10n,
  ) {
    switch (state.step) {
      case ChangePasswordStep.sendOtp:
        return _buildSendOtpStep(context, isLoading, l10n);
      case ChangePasswordStep.enterOtp:
        return _buildEnterOtpStep(context, state, isLoading, l10n);
      case ChangePasswordStep.enterNewPassword:
        return _buildEnterNewPasswordStep(context, isLoading, l10n);
    }
  }

  Widget _buildSendOtpStep(
    BuildContext context,
    bool isLoading,
    AppLocalizations l10n,
  ) {
    return DokalCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: AppSpacing.md.h),
                    Text(
                      l10n.securityChangePasswordSendingCode,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
              child: Text(
                l10n.securityChangePasswordSendCodeHint,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnterOtpStep(
    BuildContext context,
    ChangePasswordState state,
    bool isLoading,
    AppLocalizations l10n,
  ) {
    return DokalCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.authResetPasswordVerifyDescription(state.email ?? ''),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: AppSpacing.xl.h),
          TextField(
            controller: _otpController,
            focusNode: _otpFocusNode,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  letterSpacing: 8,
                  fontWeight: FontWeight.w600,
                ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: l10n.securityChangePasswordOtpLabel,
              hintText: l10n.authVerifyEmailOtpHint,
              counterText: '',
            ),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.md.h),
          DokalButton.primary(
            onPressed: isLoading || _otpController.text.trim().length != 6
                ? null
                : () => context.read<ChangePasswordCubit>().verifyOtp(
                      token: _otpController.text.trim(),
                    ),
            isLoading: isLoading,
            child: Text(l10n.authVerifyEmailVerify),
          ),
          SizedBox(height: AppSpacing.sm.h),
          OutlinedButton(
            onPressed: isLoading
                ? null
                : () => context.read<ChangePasswordCubit>().resendOtp(),
            child: Text(l10n.authVerifyEmailResend),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterNewPasswordStep(
    BuildContext context,
    bool isLoading,
    AppLocalizations l10n,
  ) {
    return DokalCard(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DokalTextField(
              controller: _password,
              label: l10n.securityNewPassword,
              hint: l10n.commonPasswordHint,
              obscureText: _obscure,
              prefixIcon: Icons.lock_rounded,
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
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
            SizedBox(height: AppSpacing.md.h),
            DokalTextField(
              controller: _confirmPassword,
              label: l10n.authResetPasswordConfirmPassword,
              hint: l10n.commonPasswordHint,
              obscureText: _confirmObscure,
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _confirmObscure = !_confirmObscure),
                icon: Icon(
                  _confirmObscure
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
              ),
              validator: (v) {
                final value = v ?? '';
                if (value.isEmpty) return l10n.commonRequired;
                if (value != _password.text) {
                  return l10n.authResetPasswordPasswordsDoNotMatch;
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg.h),
            DokalButton.primary(
              onPressed: isLoading
                  ? null
                  : () {
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      context.read<ChangePasswordCubit>().updatePassword(
                            newPassword: _password.text,
                          );
                    },
              isLoading: isLoading,
              child: Text(l10n.authResetPasswordUpdateButton),
            ),
          ],
        ),
      ),
    );
  }
}
