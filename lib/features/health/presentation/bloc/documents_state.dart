part of 'documents_cubit.dart';

enum DocumentsStatus { initial, loading, success, failure }

class DocumentsState extends Equatable {
  const DocumentsState({
    required this.status,
    required this.documents,
    this.error,
  });

  const DocumentsState.initial()
      : status = DocumentsStatus.initial,
        documents = const [],
        error = null;

  final DocumentsStatus status;
  final List<HealthDocument> documents;
  final String? error;

  DocumentsState copyWith({
    DocumentsStatus? status,
    List<HealthDocument>? documents,
    String? error,
  }) {
    return DocumentsState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, documents, error];
}

