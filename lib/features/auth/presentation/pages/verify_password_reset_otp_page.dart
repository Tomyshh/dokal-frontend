import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/verify_password_reset_cubit.dart';
import '../bloc/verify_password_reset_state.dart';

class VerifyPasswordResetOtpPage extends StatefulWidget {
  const VerifyPasswordResetOtpPage({super.key, required this.email});

  final String email;

  @override
  State<VerifyPasswordResetOtpPage> createState() =>
      _VerifyPasswordResetOtpPageState();
}

class _VerifyPasswordResetOtpPageState extends State<VerifyPasswordResetOtpPage> {
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _submitOtp(BuildContext context) {
    final code = _otpController.text.trim();
    if (code.length != 6) return;
    context.read<VerifyPasswordResetCubit>().verify(
          email: widget.email.trim(),
          token: code,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<VerifyPasswordResetCubit>(),
      child: BlocListener<VerifyPasswordResetCubit, VerifyPasswordResetState>(
        listenWhen: (prev, curr) =>
            curr.status == VerifyPasswordResetStatus.verifySuccess,
        listener: (context, state) {
          if (state.status == VerifyPasswordResetStatus.verifySuccess) {
            context.push('/forgot-password/reset', extra: widget.email.trim());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            foregroundColor: AppColors.primary,
            leading: BackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/forgot-password');
                }
              },
            ),
          ),
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
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl.h),
                  Text(
                    l10n.authResetPasswordVerifyTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    l10n.authResetPasswordVerifyDescription(widget.email.trim()),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  DokalCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextField(
                            controller: _otpController,
                            focusNode: _otpFocusNode,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  letterSpacing: 8,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: l10n.securityChangePasswordOtpLabel,
                              hintText: l10n.authVerifyEmailOtpHint,
                              counterText: '',
                            ),
                            cursorColor: AppColors.primary,
                            onChanged: (_) => setState(() {}),
                        ),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        BlocConsumer<VerifyPasswordResetCubit,
                            VerifyPasswordResetState>(
                          listener: (context, state) {
                            if (state.status ==
                                VerifyPasswordResetStatus.resendSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(l10n.authVerifyEmailResentSnack),
                                ),
                              );
                            }
                            if (state.status ==
                                VerifyPasswordResetStatus.failure) {
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
                            final isLoading =
                                state.status == VerifyPasswordResetStatus.loading;
                            final canSubmit =
                                _otpController.text.trim().length == 6;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DokalButton.primary(
                                  onPressed: isLoading || !canSubmit
                                      ? null
                                      : () => _submitOtp(context),
                                  isLoading: isLoading,
                                  child: Text(l10n.authVerifyEmailVerify),
                                ),
                                SizedBox(height: AppSpacing.sm.h),
                                DokalButton.outline(
                                  onPressed: isLoading
                                      ? null
                                      : () => context
                                          .read<VerifyPasswordResetCubit>()
                                          .resend(email: widget.email.trim()),
                                  child: Text(l10n.authVerifyEmailResend),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

