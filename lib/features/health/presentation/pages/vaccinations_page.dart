import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/repositories/health_repository.dart';
import '../bloc/health_list_cubit.dart';
import '../widgets/health_list_page_scaffold.dart';

class VaccinationsPage extends StatelessWidget {
  const VaccinationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HealthListCubit>(param1: HealthListType.vaccinations),
      child: const HealthListPageScaffold(
        title: 'Vaccinations',
        emptyTitle: 'Aucun vaccin enregistré',
        emptySubtitle: 'Suivez vos vaccins et rappels.',
        emptyIcon: Icons.vaccines_rounded,
        itemIcon: Icons.vaccines_rounded,
      ),
    );
  }
}

