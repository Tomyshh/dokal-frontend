import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
import '../bloc/forgot_password_cubit.dart';
import '../bloc/forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPasswordCubit>(),
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
                  'Mot de passe oublié',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Nous vous enverrons un lien de réinitialisation.',
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
                          prefixIcon: Icons.mail_rounded,
                          textInputAction: TextInputAction.done,
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Email requis';
                            if (!value.contains('@')) return 'Email invalide';
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(context),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                          listener: (context, state) {
                            if (state.status == ForgotPasswordStatus.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Email envoyé. Vérifiez votre boîte de réception.',
                                  ),
                                ),
                              );
                            }
                            if (state.status == ForgotPasswordStatus.failure) {
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
                                  state.status == ForgotPasswordStatus.loading,
                              child: const Text('Envoyer le lien'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Retour à la connexion'),
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
    context.read<ForgotPasswordCubit>().submit(
          email: _email.text.trim(),
        );
  }
}

