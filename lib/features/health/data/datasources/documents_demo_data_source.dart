import '../../domain/entities/health_document.dart';

abstract class DocumentsDemoDataSource {
  List<HealthDocument> list();
  void addDemo();
}

class DocumentsDemoDataSourceImpl implements DocumentsDemoDataSource {
  final _docs = <HealthDocument>[];

  int _i = 0;

  @override
  List<HealthDocument> list() => List.unmodifiable(_docs);

  @override
  void addDemo() {
    _i++;
    _docs.insert(
      0,
      HealthDocument(
        id: 'doc_$_i',
        title: 'Document $_i',
        typeLabel: 'Compte-rendu',
        dateLabel: 'Aujourd’hui',
      ),
    );
  }
}

