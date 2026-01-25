import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
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
    return BlocProvider(
      create: (_) => sl<VerifyEmailCubit>(),
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
                  'Vérifiez votre email',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "Nous avons envoyé un email de confirmation à ${widget.email}. "
                  "Cliquez sur le lien dans l'email puis revenez dans l'application.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                DokalCard(
                  child: Column(
                    children: [
                      DokalButton.primary(
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthRefreshRequested());
                          context.go('/login');
                        },
                        child: const Text("J'ai vérifié, retourner à la connexion"),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
                        listener: (context, state) {
                          if (state.status == VerifyEmailStatus.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email de confirmation renvoyé.'),
                              ),
                            );
                          }
                          if (state.status == VerifyEmailStatus.failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.errorMessage ?? 'Erreur'),
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
                            isLoading: state.status == VerifyEmailStatus.loading,
                            child: const Text("Renvoyer l'email"),
                          );
                        },
                      ),
                    ],
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
      ),
    );
  }
}

