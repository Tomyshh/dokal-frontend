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
import '../bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.redirectTo});

  /// URL de redirection après inscription réussie
  final String? redirectTo;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
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
                  l10n.authRegisterTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  l10n.authRegisterSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: AppSpacing.xl.h),
                DokalCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DokalTextField(
                                controller: _firstName,
                                label: l10n.authFirstName,
                                prefixIcon: Icons.person_rounded,
                                textInputAction: TextInputAction.next,
                                validator: (v) => (v ?? '').trim().isEmpty
                                    ? l10n.commonRequired
                                    : null,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md.w),
                            Expanded(
                              child: DokalTextField(
                                controller: _lastName,
                                label: l10n.authLastName,
                                textInputAction: TextInputAction.next,
                                validator: (v) => (v ?? '').trim().isEmpty
                                    ? l10n.commonRequired
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        DokalTextField(
                          controller: _email,
                          label: l10n.commonEmail,
                          hint: l10n.commonEmailHint,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.mail_rounded,
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return l10n.commonEmailRequired;
                            if (!value.contains('@')) {
                              return l10n.commonEmailInvalid;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        DokalTextField(
                          controller: _password,
                          label: l10n.commonPassword,
                          hint: l10n.commonPasswordHint,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
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
                          onFieldSubmitted: (_) => _submit(context),
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        BlocConsumer<RegisterBloc, RegisterState>(
                          listener: (context, state) {
                            if (state.status == RegisterStatus.success) {
                              context.go(
                                '/verify-email',
                                extra: _email.text.trim(),
                              );
                            }
                            if (state.status == RegisterStatus.failure) {
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
                              isLoading: state.status == RegisterStatus.loading,
                              child: Text(l10n.commonContinue),
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        DokalButton.outline(
                          onPressed: () {
                            final redirect = widget.redirectTo;
                            if (redirect != null && redirect.isNotEmpty) {
                              context.go(
                                '/login?redirect=${Uri.encodeComponent(redirect)}',
                              );
                            } else {
                              context.go('/login');
                            }
                          },
                          child: Text(l10n.authAlreadyHaveAccount),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: Text(l10n.authContinueWithoutAccount),
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
    context.read<RegisterBloc>().add(
      RegisterSubmitted(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      ),
    );
  }
}
