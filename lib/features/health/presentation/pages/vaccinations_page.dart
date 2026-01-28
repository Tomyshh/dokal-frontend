import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/repositories/health_repository.dart';
import '../bloc/health_list_cubit.dart';
import '../widgets/health_list_page_scaffold.dart';

class VaccinationsPage extends StatelessWidget {
  const VaccinationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<HealthListCubit>(param1: HealthListType.vaccinations),
      child: HealthListPageScaffold(
        title: l10n.healthVaccinationsTitle,
        emptyTitle: l10n.vaccinationsEmptyTitle,
        emptySubtitle: l10n.vaccinationsEmptySubtitle,
        emptyIcon: Icons.vaccines_rounded,
        itemIcon: Icons.vaccines_rounded,
      ),
    );
  }
}
