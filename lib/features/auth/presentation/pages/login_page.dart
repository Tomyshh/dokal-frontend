import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.redirectTo});

  /// URL de redirection après connexion réussie
  final String? redirectTo;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  bool get _isAccountInline => (widget.redirectTo ?? '') == '/account';

  bool get _isBookingGate =>
      (widget.redirectTo ?? '').trim().startsWith('/booking/');

  String? get _safeRedirectTo {
    final raw = widget.redirectTo;
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;
    if (uri.hasScheme || uri.host.isNotEmpty) return null;
    if (!uri.path.startsWith('/')) return null;
    return uri.toString();
  }

  String? get _bookingPractitionerId {
    final redirect = (widget.redirectTo ?? '').trim();
    final match = RegExp(r'^/booking/([^/?]+)').firstMatch(redirect);
    return match?.group(1);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
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
                    color: AppColors.primary,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: AppSpacing.xxl.h),
                Text(
                  l10n.authLoginTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  l10n.authLoginSubtitle,
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
                        BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state.status == LoginStatus.success) {
                              context.read<AuthBloc>().add(
                                const AuthRefreshRequested(),
                              );
                              // Rediriger vers la page demandée ou le home
                              final redirect = _safeRedirectTo;
                              if (redirect != null) {
                                context.go(redirect);
                              }
                              // Sinon, le router redirigera automatiquement vers /home
                            }
                            if (state.status == LoginStatus.failure) {
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
                              isLoading: state.status == LoginStatus.loading,
                              child: Text(l10n.authLoginButton),
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.go('/forgot-password'),
                            child: Text(l10n.authForgotPasswordCta),
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs.h),
                        DokalButton.outline(
                          onPressed: () {
                            final redirect = widget.redirectTo;
                            if (redirect != null && redirect.isNotEmpty) {
                              context.go(
                                '/register?redirect=${Uri.encodeComponent(redirect)}',
                              );
                            } else {
                              context.go('/register');
                            }
                          },
                          child: Text(l10n.authCreateAccountCta),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                if (_isBookingGate)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                          return;
                        }
                        final id = _bookingPractitionerId;
                        if (id != null && id.isNotEmpty) {
                          context.go('/home/practitioner/$id');
                        } else {
                          context.go('/home/search');
                        }
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: Text(l10n.commonBack),
                    ),
                  )
                else if (_isAccountInline)
                  const SizedBox.shrink()
                else
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
    context.read<LoginBloc>().add(
      LoginSubmitted(email: _email.text.trim(), password: _password.text),
    );
  }
}
