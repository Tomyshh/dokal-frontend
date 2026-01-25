import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/repositories/health_repository.dart';
import '../bloc/health_list_cubit.dart';
import '../widgets/health_list_page_scaffold.dart';

class AllergiesPage extends StatelessWidget {
  const AllergiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HealthListCubit>(param1: HealthListType.allergies),
      child: const HealthListPageScaffold(
        title: 'Allergies',
        emptyTitle: 'Aucune allergie',
        emptySubtitle: 'Déclarez vos allergies pour votre sécurité.',
        emptyIcon: Icons.warning_amber_rounded,
        itemIcon: Icons.warning_amber_rounded,
      ),
    );
  }
}

