import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/repositories/health_repository.dart';
import '../bloc/health_list_cubit.dart';
import '../widgets/health_list_page_scaffold.dart';

class MedicalConditionsPage extends StatelessWidget {
  const MedicalConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<HealthListCubit>(param1: HealthListType.conditions),
      child: HealthListPageScaffold(
        title: l10n.healthConditionsTitle,
        emptyTitle: l10n.conditionsEmptyTitle,
        emptySubtitle: l10n.conditionsEmptySubtitle,
        emptyIcon: Icons.healing_rounded,
        itemIcon: Icons.healing_rounded,
      ),
    );
  }
}
