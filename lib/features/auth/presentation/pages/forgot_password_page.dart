import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DokalButton.primary(
                        onPressed: _submit,
                        isLoading: _loading,
                        child: const Text('Envoyer le lien'),
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
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email envoyé (démo). Vérifiez votre boîte de réception.'),
      ),
    );
  }
}

