import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../bloc/auth_bloc.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _code.dispose();
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
                'Vérifier votre email',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Un code a été envoyé à ${widget.email}.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              DokalCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DokalTextField(
                        controller: _code,
                        label: 'Code',
                        hint: 'ex: 123456',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icons.verified_rounded,
                        validator: (v) {
                          final value = (v ?? '').trim();
                          if (value.isEmpty) return 'Code requis';
                          if (value.length < 4) return 'Code invalide';
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DokalButton.primary(
                        onPressed: _submit,
                        isLoading: _loading,
                        child: const Text('Confirmer'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DokalButton.outline(
                        onPressed: _loading
                            ? null
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Code renvoyé (démo).'),
                                  ),
                                );
                              },
                        child: const Text('Renvoyer le code'),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Retour'),
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
    context.read<AuthBloc>().add(const AuthRefreshRequested());
    context.go('/home');
  }
}

