import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/health_document.dart';
import '../bloc/documents_cubit.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DocumentsCubit>(),
      child: BlocConsumer<DocumentsCubit, DocumentsState>(
        listener: (context, state) {
          if (state.status == DocumentsStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur')),
            );
          }
        },
        builder: (context, state) {
          final docs = state.documents;
          return Scaffold(
            appBar: const DokalAppBar(title: 'Documents'),
            body: state.status == DocumentsStatus.loading
                ? const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: DokalLoader(lines: 5),
                  )
                : docs.isEmpty
                    ? const DokalEmptyState(
                        title: 'Aucun document',
                        subtitle:
                            'Vos ordonnances et résultats apparaîtront ici.',
                        icon: Icons.description_rounded,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: docs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) => _DocTile(doc: docs[i]),
                      ),
            floatingActionButton: FloatingActionButton.small(
              onPressed: () => context.read<DocumentsCubit>().addDemo(),
              child: const Icon(Icons.add_rounded, size: 20),
            ),
          );
        },
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  const _DocTile({required this.doc});

  final HealthDocument doc;

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (ctx) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.open_in_new_rounded, size: 20),
                    title: Text(
                      'Ouvrir',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Ouverture disponible bientôt')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_rounded, size: 20),
                    title: Text(
                      'Partager',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Partage disponible bientôt')),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            );
          },
        );
      },
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: const Icon(
              Icons.description_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${doc.typeLabel} • ${doc.dateLabel}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

