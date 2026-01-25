import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/branding/icononly_transparent_nobuffer.png',
                    height: 56,color: AppColors.primary,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Connexion',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Accédez à vos rendez-vous, messages et documents.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                DokalCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DokalTextField(
                          controller: _email,
                          label: 'Email',
                          hint: 'ex: nom@domaine.com',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.mail_rounded,
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Email requis';
                            if (!value.contains('@')) return 'Email invalide';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DokalTextField(
                          controller: _password,
                          label: 'Mot de passe',
                          hint: '••••••••',
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
                            if (value.isEmpty) return 'Mot de passe requis';
                            if (value.length < 6) {
                              return 'Minimum 6 caractères';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(context),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state.status == LoginStatus.success) {
                              context.read<AuthBloc>().add(
                                    const AuthRefreshRequested(),
                                  );
                              // Rediriger vers la page demandée ou le home
                              final redirect = widget.redirectTo;
                              if (redirect != null && redirect.isNotEmpty) {
                                context.go(redirect);
                              }
                              // Sinon, le router redirigera automatiquement vers /home
                            }
                            if (state.status == LoginStatus.failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMessage ?? 'Erreur'),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return DokalButton.primary(
                              onPressed: () => _submit(context),
                              isLoading: state.status == LoginStatus.loading,
                              child: const Text('Se connecter'),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.go('/forgot-password'),
                            child: const Text('Mot de passe oublié ?'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        DokalButton.outline(
                          onPressed: () {
                            final redirect = widget.redirectTo;
                            if (redirect != null && redirect.isNotEmpty) {
                              context.go('/register?redirect=${Uri.encodeComponent(redirect)}');
                            } else {
                              context.go('/register');
                            }
                          },
                          child: const Text('Créer un compte'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Continuer sans compte'),
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
          LoginSubmitted(
            email: _email.text.trim(),
            password: _password.text,
          ),
        );
  }
}

