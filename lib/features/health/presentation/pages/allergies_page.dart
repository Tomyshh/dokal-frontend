import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/repositories/health_repository.dart';
import '../bloc/health_list_cubit.dart';
import '../widgets/health_list_page_scaffold.dart';

class AllergiesPage extends StatelessWidget {
  const AllergiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<HealthListCubit>(param1: HealthListType.allergies),
      child: HealthListPageScaffold(
        title: l10n.healthAllergiesTitle,
        emptyTitle: l10n.allergiesEmptyTitle,
        emptySubtitle: l10n.allergiesEmptySubtitle,
        emptyIcon: Icons.warning_amber_rounded,
        itemIcon: Icons.warning_amber_rounded,
      ),
    );
  }
}
