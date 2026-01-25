import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
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
    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
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
                    height: 56,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Créer un compte',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Tous les champs sont obligatoires.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
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
                                label: 'Prénom',
                                prefixIcon: Icons.person_rounded,
                                textInputAction: TextInputAction.next,
                                validator: (v) => (v ?? '').trim().isEmpty
                                    ? 'Requis'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: DokalTextField(
                                controller: _lastName,
                                label: 'Nom',
                                textInputAction: TextInputAction.next,
                                validator: (v) => (v ?? '').trim().isEmpty
                                    ? 'Requis'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
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
                                  content: Text(state.errorMessage ?? 'Erreur'),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return DokalButton.primary(
                              onPressed: () => _submit(context),
                              isLoading:
                                  state.status == RegisterStatus.loading,
                              child: const Text('Continuer'),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        DokalButton.outline(
                          onPressed: () {
                            final redirect = widget.redirectTo;
                            if (redirect != null && redirect.isNotEmpty) {
                              context.go('/login?redirect=${Uri.encodeComponent(redirect)}');
                            } else {
                              context.go('/login');
                            }
                          },
                          child: const Text("J'ai déjà un compte"),
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
