import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/repositories/health_repository.dart';
import '../bloc/health_list_cubit.dart';
import '../widgets/health_list_page_scaffold.dart';

class MedicationsPage extends StatelessWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HealthListCubit>(param1: HealthListType.medications),
      child: const HealthListPageScaffold(
        title: 'Médicaments',
        emptyTitle: 'Aucun médicament',
        emptySubtitle: 'Ajoutez vos traitements en cours.',
        emptyIcon: Icons.medication_rounded,
        itemIcon: Icons.medication_rounded,
      ),
    );
  }
}

