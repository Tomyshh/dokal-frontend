import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({super.key});

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DokalAppBar(title: 'Nouveau message'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Écrire au cabinet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Réponse sous 24-48h.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: DokalCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DokalTextField(
                          controller: _subject,
                          label: 'Objet',
                          hint: 'ex: Résultats, question…',
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.subject_rounded,
                          validator: (v) =>
                              (v ?? '').trim().isEmpty ? 'Objet requis' : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _message,
                            maxLines: null,
                            expands: true,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              labelText: 'Message',
                              hintText: 'Écrivez votre message…',
                              alignLabelWithHint: true,
                              prefixIcon: const Icon(Icons.chat_bubble_rounded, size: 18),
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                            validator: (v) => (v ?? '').trim().length < 10
                                ? 'Minimum 10 caractères'
                                : null,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DokalButton.primary(
                          onPressed: () {
                            if (!(_formKey.currentState?.validate() ?? false)) return;
                            context.go('/messages/c/demo1');
                          },
                          leading: const Icon(Icons.send_rounded),
                          child: const Text('Envoyer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

