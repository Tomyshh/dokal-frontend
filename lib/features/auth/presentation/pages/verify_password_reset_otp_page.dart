import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
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
            context.go('/forgot-password/reset', extra: widget.email.trim());
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            foregroundColor: Colors.white,
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
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl.h),
                  Text(
                    l10n.authResetPasswordVerifyTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    l10n.authResetPasswordVerifyDescription(widget.email.trim()),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  DokalCard(
                    color: Colors.transparent,
                    borderColor: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
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
                                color: Colors.white,
                              ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: l10n.authVerifyEmailOtpHint,
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadii.md.r),
                              borderSide:
                                  const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadii.md.r),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadii.md.r),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          cursorColor: Colors.white,
                          onChanged: (_) => setState(() {}),
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
                                FilledButton(
                                  onPressed: isLoading || !canSubmit
                                      ? null
                                      : () => _submitOtp(context),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primary,
                                    disabledBackgroundColor:
                                        Colors.white.withValues(alpha: 0.5),
                                    disabledForegroundColor: AppColors.primary
                                        .withValues(alpha: 0.6),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadii.md.r,
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: state.status ==
                                          VerifyPasswordResetStatus.loading
                                      ? SizedBox(
                                          height: 20.h,
                                          width: 20.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        )
                                      : Text(l10n.authVerifyEmailVerify),
                                ),
                                SizedBox(height: AppSpacing.sm.h),
                                OutlinedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context
                                          .read<VerifyPasswordResetCubit>()
                                          .resend(email: widget.email.trim()),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(
                                      color: isLoading
                                          ? Colors.white.withValues(alpha: 0.4)
                                          : Colors.white,
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(AppRadii.md.r),
                                    ),
                                  ),
                                  child: Text(l10n.authVerifyEmailResend),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      l10n.commonBack,
                      style: const TextStyle(color: Colors.white),
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

