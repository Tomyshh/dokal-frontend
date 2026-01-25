import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../bloc/booking_bloc.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({super.key});

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final practitionerId = context.read<BookingBloc>().state.practitionerId;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text(
          'Instructions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Avant le rendez-vous, merci de vérifier ces points.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xl),
        const DokalCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Bullet('Apportez votre carte vitale et votre ordonnance si besoin.'),
              SizedBox(height: 10),
              _Bullet('Arrivez 10 minutes en avance pour les formalités.'),
              SizedBox(height: 10),
              _Bullet('En cas d’annulation, prévenez dès que possible.'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        DokalCard(
          child: Row(
            children: [
              Checkbox(
                value: _accepted,
                onChanged: (v) => setState(() => _accepted = v ?? false),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'J’ai lu et j’accepte ces instructions.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        DokalButton.primary(
          onPressed: !_accepted
              ? null
              : () {
                  context.read<BookingBloc>().add(const BookingInstructionsAccepted());
                  context.go('/booking/$practitionerId/slot');
                },
          child: const Text('Continuer'),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(Icons.check_rounded, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
      ],
    );
  }
}

