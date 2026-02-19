import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../../../router/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/register_bloc.dart';

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
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscure = true;
  bool _expanded = false;

  final _registerFormKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _registerEmail = TextEditingController();
  final _registerPassword = TextEditingController();
  bool _registerObscure = true;

  _AuthSheetView _view = _AuthSheetView.login;
  int _slideDir = 1;

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
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _registerEmail.dispose();
    _registerPassword.dispose();
    super.dispose();
  }

  void _expand() {
    if (_expanded) return;
    setState(() {
      _expanded = true;
      _view = _AuthSheetView.login;
    });
  }

  void _collapse() {
    if (!_expanded) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _expanded = false;
      _view = _AuthSheetView.login;
    });
  }

  void _goToRegister() {
    if (_view == _AuthSheetView.register) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _view = _AuthSheetView.register;
      _slideDir = 1;
    });
  }

  void _goToLogin() {
    if (_view == _AuthSheetView.login) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _view = _AuthSheetView.login;
      _slideDir = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final base = Theme.of(context);
            final viewInsets = MediaQuery.viewInsetsOf(context);
            const white = Colors.white;

            final heroHeight = (constraints.maxHeight * 0.46)
                .clamp(300.0.h, 460.0.h)
                .toDouble();
            final collapsedSheetHeight = 300.h;
            final expandedSheetHeight = (constraints.maxHeight - heroHeight * 0.25)
                .clamp(420.0.h, constraints.maxHeight)
                .toDouble();
            final sheetHeight =
                _expanded ? expandedSheetHeight : collapsedSheetHeight;

            final header = SizedBox(
              height: heroHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl.w,
                  vertical: AppSpacing.lg.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/branding/icononly_transparent_nobuffer.png',
                      height: 56.h,
                      color: const Color(0xFFD4AF37),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Text(
                      l10n.authLoginTitle,
                      style: base.textTheme.headlineMedium?.copyWith(
                        color: white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      l10n.authLoginSubtitle,
                      style: base.textTheme.bodyLarge?.copyWith(
                        color: white.withValues(alpha: 0.90),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            );

            Widget sheetBody() {
              if (!_expanded) {
                return GestureDetector(
                  onTap: _expand,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xl.w,
                      AppSpacing.lg.h,
                      AppSpacing.xl.w,
                      AppSpacing.lg.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/branding/icononly_transparent_nobuffer.png',
                              height: 36.h,
                              color: AppColors.primary,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: AppSpacing.sm.w),
                            Text(
                              'Dokal',
                              style: base.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        Text(
                          l10n.authLoginTitle,
                          textAlign: TextAlign.center,
                          style: base.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs.h),
                        Text(
                          l10n.authLoginSubtitle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: base.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        FilledButton(
                          onPressed: _expand,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            minimumSize: Size(double.infinity, 46.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.onboardingStartButton,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              Widget loginView() {
                return SingleChildScrollView(
                  key: const ValueKey('loginView'),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xl.w,
                    AppSpacing.xxs.h,
                    AppSpacing.xl.w,
                    AppSpacing.lg.h + viewInsets.bottom,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.authLoginTitle,
                                    style: base.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.2,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.xs.h),
                                  Text(
                                    l10n.authLoginSubtitle,
                                    style: base.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _collapse,
                              icon: const Icon(Icons.close_rounded),
                              color: AppColors.textSecondary,
                              tooltip: MaterialLocalizations.of(context)
                                  .closeButtonTooltip,
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        DokalTextField(
                          controller: _email,
                          focusNode: _emailFocus,
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
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_passwordFocus),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        DokalTextField(
                          controller: _password,
                          focusNode: _passwordFocus,
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
                        SizedBox(height: AppSpacing.sm.h),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () => context.go('/forgot-password'),
                            child: Text(l10n.authForgotPasswordCta),
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                          BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state.status == LoginStatus.success) {
                              final authBloc = context.read<AuthBloc>();
                              if (state.session != null) {
                                authBloc.add(
                                  AuthSessionRestored(state.session!),
                                );
                              } else {
                                authBloc.add(const AuthRefreshRequested());
                              }
                              // Toujours rediriger vers l'onglet Home après connexion.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.l10n.authLoginSuccess),
                                ),
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                appRouter.go('/home');
                              });
                            }
                            if (state.status == LoginStatus.needsEmailVerification &&
                                state.email != null &&
                                state.email!.isNotEmpty) {
                              final email = state.email;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.mounted) {
                                  GoRouter.of(context).go(
                                    '/verify-email',
                                    extra: email,
                                  );
                                }
                              });
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
                            final isLoading =
                                state.status == LoginStatus.loading;
                            return FilledButton(
                              onPressed:
                                  isLoading ? null : () => _submit(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: white,
                                disabledBackgroundColor:
                                    AppColors.primary.withValues(alpha: 0.55),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                minimumSize: Size(double.infinity, 46.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      l10n.authLoginButton,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        Divider(height: 1.h, color: AppColors.outline),
                        SizedBox(height: AppSpacing.lg.h),
                        BlocBuilder<LoginBloc, LoginState>(
                          buildWhen: (prev, curr) =>
                              prev.status != curr.status ||
                              curr.status == LoginStatus.loading,
                          builder: (context, state) {
                            final isLoading =
                                state.status == LoginStatus.loading;
                            return OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context
                                      .read<LoginBloc>()
                                      .add(const LoginWithGoogleRequested()),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textPrimary,
                                side: const BorderSide(color: AppColors.outline),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                minimumSize: Size(double.infinity, 46.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/google.png',
                                    width: 18.r,
                                    height: 18.r,
                                  ),
                                  SizedBox(width: AppSpacing.sm.w),
                                  Text(
                                    l10n.authContinueWithGoogle,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        OutlinedButton(
                          onPressed: _goToRegister,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.35),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            minimumSize: Size(double.infinity, 46.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            l10n.authCreateAccountCta,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        if (_isBookingGate)
                          TextButton.icon(
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
                          )
                        else if (!_isAccountInline)
                          TextButton(
                            onPressed: () => context.go('/home'),
                            child: Text(l10n.authContinueWithoutAccount),
                          ),
                      ],
                    ),
                  ),
                );
              }

              Widget registerView() {
                return BlocProvider(
                  create: (_) => sl<RegisterBloc>(),
                  child: SingleChildScrollView(
                    key: const ValueKey('registerView'),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xl.w,
                      AppSpacing.xxs.h,
                      AppSpacing.xl.w,
                      AppSpacing.lg.h + viewInsets.bottom,
                    ),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: _goToLogin,
                                icon: const Icon(Icons.arrow_back_rounded),
                                color: AppColors.textSecondary,
                                tooltip: MaterialLocalizations.of(context)
                                    .backButtonTooltip,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.authRegisterTitle,
                                      style: base.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.2,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: AppSpacing.xs.h),
                                    Text(
                                      l10n.authRegisterSubtitle,
                                      style:
                                          base.textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _collapse,
                                icon: const Icon(Icons.close_rounded),
                                color: AppColors.textSecondary,
                                tooltip: MaterialLocalizations.of(context)
                                    .closeButtonTooltip,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.lg.h),
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
                            controller: _registerEmail,
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
                            controller: _registerPassword,
                            label: l10n.commonPassword,
                            hint: l10n.commonPasswordHint,
                            obscureText: _registerObscure,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icons.lock_rounded,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() =>
                                  _registerObscure = !_registerObscure),
                              icon: Icon(
                                _registerObscure
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
                            onFieldSubmitted: (_) => _submitRegister(context),
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          BlocConsumer<RegisterBloc, RegisterState>(
                            listener: (context, state) {
                              if (state.status == RegisterStatus.success) {
                                context.go(
                                  '/verify-email',
                                  extra: _registerEmail.text.trim(),
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
                              final isLoading =
                                  state.status == RegisterStatus.loading;
                              return FilledButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _submitRegister(context),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: white,
                                  disabledBackgroundColor: AppColors.primary
                                      .withValues(alpha: 0.55),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  minimumSize: Size(double.infinity, 46.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child:
                                            const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        l10n.commonContinue,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              );
                            },
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          OutlinedButton(
                            onPressed: _goToLogin,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(
                                color:
                                    AppColors.primary.withValues(alpha: 0.35),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              minimumSize: Size(double.infinity, 46.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              l10n.authAlreadyHaveAccount,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          if (_isBookingGate)
                            TextButton.icon(
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
                            )
                          else if (!_isAccountInline)
                            TextButton(
                              onPressed: () => context.go('/home'),
                              child: Text(l10n.authContinueWithoutAccount),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final child = _view == _AuthSheetView.login
                  ? loginView()
                  : registerView();

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final isIncoming = child.key ==
                      ValueKey(_view == _AuthSheetView.login
                          ? 'loginView'
                          : 'registerView');
                  // Note: pour l'ancienne page, l'animation est inversée (1 -> 0),
                  // donc on inverse le tween afin d'obtenir un slide sortant naturel.
                  final beginDx = isIncoming
                      ? _slideDir.toDouble()
                      : (-_slideDir).toDouble();
                  final endDx = 0.0;
                  final slide = Tween<Offset>(
                    begin: Offset(beginDx * 0.08, 0),
                    end: Offset(endDx, 0),
                  ).animate(animation);
                  return ClipRect(
                    child: SlideTransition(
                      position: slide,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                child: child,
              );
            }

            final sheet = AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              height: sheetHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.r),
                  topRight: Radius.circular(28.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 24.r,
                    offset: Offset(0, -8.h),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.r),
                  topRight: Radius.circular(28.r),
                ),
                child: sheetBody(),
              ),
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/get_started.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                
                SafeArea(
                  child: Stack(
                    children: [
                      Positioned.fill(child: header),
                      Align(alignment: Alignment.bottomCenter, child: sheet),
                    ],
                  ),
                ),
              ],
            );
          },
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

  void _submitRegister(BuildContext context) {
    if (!(_registerFormKey.currentState?.validate() ?? false)) return;
    context.read<RegisterBloc>().add(
          RegisterSubmitted(
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            email: _registerEmail.text.trim(),
            password: _registerPassword.text,
          ),
        );
  }
}

enum _AuthSheetView { login, register }
