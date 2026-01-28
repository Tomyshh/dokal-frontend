import '../../domain/entities/health_item.dart';
import '../../domain/repositories/health_repository.dart';

abstract class HealthDemoDataSource {
  List<HealthItem> list(HealthListType type);
  void addDemo(HealthListType type);
}

class HealthDemoDataSourceImpl implements HealthDemoDataSource {
  final Map<HealthListType, List<HealthItem>> _data = {
    HealthListType.conditions: <HealthItem>[],
    HealthListType.medications: <HealthItem>[],
    HealthListType.allergies: <HealthItem>[],
    HealthListType.vaccinations: <HealthItem>[],
  };

  int _i = 0;

  @override
  List<HealthItem> list(HealthListType type) =>
      List.unmodifiable(_data[type] ?? const []);

  @override
  void addDemo(HealthListType type) {
    _i++;
    final label = switch (type) {
      HealthListType.conditions => 'Condition $_i',
      HealthListType.medications => 'Médicament $_i',
      HealthListType.allergies => 'Allergie $_i',
      HealthListType.vaccinations => 'Vaccin $_i',
    };
    final existing = _data[type] ?? <HealthItem>[];
    _data[type] = [
      HealthItem(id: '${type.name}_$_i', label: label),
      ...existing,
    ];
  }
}
