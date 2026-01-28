import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
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
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<VerifyEmailCubit>(),
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
                  l10n.authVerifyEmailTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  l10n.authVerifyEmailDescription(widget.email),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: AppSpacing.xl.h),
                DokalCard(
                  child: Column(
                    children: [
                      DokalButton.primary(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            const AuthRefreshRequested(),
                          );
                          context.go('/login');
                        },
                        child: Text(l10n.authVerifyEmailCheckedBackToLogin),
                      ),
                      SizedBox(height: AppSpacing.sm.h),
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
                          return DokalButton.outline(
                            onPressed: state.status == VerifyEmailStatus.loading
                                ? null
                                : () => context.read<VerifyEmailCubit>().resend(
                                    email: widget.email.trim(),
                                  ),
                            isLoading:
                                state.status == VerifyEmailStatus.loading,
                            child: Text(l10n.authVerifyEmailResend),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(l10n.commonBack),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
