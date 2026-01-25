import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/health_document.dart';
import '../../domain/usecases/add_demo_document.dart';
import '../../domain/usecases/get_documents.dart';

part 'documents_state.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit({
    required GetDocuments getDocuments,
    required AddDemoDocument addDemoDocument,
  })  : _getDocuments = getDocuments,
        _addDemoDocument = addDemoDocument,
        super(const DocumentsState.initial());

  final GetDocuments _getDocuments;
  final AddDemoDocument _addDemoDocument;

  Future<void> load() async {
    emit(state.copyWith(status: DocumentsStatus.loading));
    final res = await _getDocuments();
    res.fold(
      (f) => emit(state.copyWith(status: DocumentsStatus.failure, error: f.message)),
      (items) => emit(
        state.copyWith(status: DocumentsStatus.success, documents: items, error: null),
      ),
    );
  }

  Future<void> addDemo() async {
    final res = await _addDemoDocument();
    res.fold(
      (f) => emit(state.copyWith(status: DocumentsStatus.failure, error: f.message)),
      (_) async => load(),
    );
  }
}

