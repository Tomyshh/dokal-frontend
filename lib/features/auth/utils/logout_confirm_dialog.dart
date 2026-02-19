import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../presentation/bloc/auth_bloc.dart';

/// Affiche un dialogue « Êtes-vous sûr de vouloir vous déconnecter ? »
/// et déclenche [AuthLogoutRequested] si l'utilisateur confirme.
void showLogoutConfirmDialog(BuildContext context) {
  final l10n = context.l10n;
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.authLogoutConfirmTitle),
      content: Text(l10n.authLogoutConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            context.read<AuthBloc>().add(const AuthLogoutRequested());
          },
          child: Text(l10n.authLogout),
        ),
      ],
    ),
  );
}
