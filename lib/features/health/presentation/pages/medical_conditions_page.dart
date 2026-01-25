import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/repositories/health_repository.dart';
import '../bloc/health_list_cubit.dart';
import '../widgets/health_list_page_scaffold.dart';

class MedicalConditionsPage extends StatelessWidget {
  const MedicalConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HealthListCubit>(param1: HealthListType.conditions),
      child: const HealthListPageScaffold(
        title: 'Conditions médicales',
        emptyTitle: 'Aucune condition',
        emptySubtitle: 'Ajoutez vos antécédents pour vos RDV.',
        emptyIcon: Icons.healing_rounded,
        itemIcon: Icons.healing_rounded,
      ),
    );
  }
}

