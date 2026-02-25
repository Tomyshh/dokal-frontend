import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/verify_email_cubit.dart';
import '../bloc/verify_email_state.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
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
    context.read<VerifyEmailCubit>().verify(
          email: widget.email.trim(),
          token: code,
        );
  }

  Widget _buildPinput(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 44.w,
      height: 52.h,
      textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.md.r),
        border: Border.all(color: AppColors.outline),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: _otpController,
        focusNode: _otpFocusNode,
        length: 6,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: defaultPinTheme,
        keyboardType: TextInputType.number,
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<VerifyEmailCubit>(),
      child: BlocListener<VerifyEmailCubit, VerifyEmailState>(
        listenWhen: (prev, curr) => curr.status == VerifyEmailStatus.verifySuccess,
        listener: (context, state) {
          if (state.status == VerifyEmailStatus.verifySuccess) {
            context.read<AuthBloc>().add(const AuthRefreshRequested());
            context.go('/');
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.xl.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Center(
                        child: _DokalLogoGold(),
                      ),
                      SizedBox(height: AppSpacing.xxl.h),
                      Text(
                        l10n.authVerifyEmailTitle,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Text(
                        l10n.authVerifyEmailDescription(widget.email),
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
                            _buildPinput(context),
                            SizedBox(height: AppSpacing.md.h),
                            BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
                              listener: (context, state) {
                            if (state.status == VerifyEmailStatus.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.authVerifyEmailResentSnack),
                                ),
                              );
                            }
                            if (state.status == VerifyEmailStatus.failure) {
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
                                state.status == VerifyEmailStatus.loading;
                            final canSubmit =
                                _otpController.text.trim().length == 6;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: isLoading || !canSubmit
                                        ? null
                                        : () => _submitOtp(context),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primary,
                                      disabledBackgroundColor:
                                          Colors.white.withValues(alpha: 0.5),
                                      disabledForegroundColor:
                                          AppColors.primary.withValues(alpha: 0.6),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(AppRadii.md.r),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: state.status == VerifyEmailStatus.loading
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
                                ),
                                SizedBox(height: AppSpacing.sm.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => context
                                            .read<VerifyEmailCubit>()
                                            .resend(
                                              email: widget.email.trim(),
                                            ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: isLoading
                                            ? Colors.white.withValues(alpha: 0.4)
                                            : Colors.white,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(AppRadii.md.r),
                                      ),
                                    ),
                                    child: Text(l10n.authVerifyEmailResend),
                                  ),
                                ),
                              ],
                            );
                          },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl.h),
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

/// Logo Dokal en dégradé or (comme l'onboarding).
class _DokalLogoGold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF1B8), // highlight
            Color(0xFFFFD166), // gold
            Color(0xFFB8860B), // deep gold
          ],
          stops: [0.0, 0.45, 1.0],
        ).createShader(rect);
      },
      child: Image.asset(
        'assets/branding/icononly_transparent_nobuffer.png',
        height: 56.h,
        fit: BoxFit.contain,
        color: Colors.white,
      ),
    );
  }
}
