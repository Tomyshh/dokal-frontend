import '../../../../core/network/api_client.dart';
import '../../domain/entities/health_item.dart';
import '../../domain/repositories/health_repository.dart';
import 'health_demo_data_source.dart';

/// Remote implementation of [HealthDemoDataSource] backed by the Dokal
/// backend REST API.
class HealthRemoteDataSourceImpl implements HealthDemoDataSource {
  HealthRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  static const _tableMap = {
    HealthListType.conditions: 'conditions',
    HealthListType.medications: 'medications',
    HealthListType.allergies: 'allergies',
    HealthListType.vaccinations: 'vaccinations',
  };

  @override
  List<HealthItem> list(HealthListType type) =>
      throw UnimplementedError('Use listAsync');

  @override
  void addDemo(HealthListType type) =>
      throw UnimplementedError('Use addItemAsync');

  Future<List<HealthItem>> listAsync(HealthListType type) async {
    final table = _tableMap[type]!;
    final data = await api.get('/api/v1/health/$table') as List<dynamic>;
    return data.map((raw) {
      final json = raw as Map<String, dynamic>;
      return HealthItem(
        id: json['id'] as String,
        label: json['name'] as String? ?? '',
        reaction: json['reaction'] as String?,
        severity: json['severity'] as String?,
        dosage: json['dosage'] as String?,
        frequency: json['frequency'] as String?,
        diagnosedOn: json['diagnosed_on'] as String?,
        startedOn: json['started_on'] as String?,
        endedOn: json['ended_on'] as String?,
        dose: json['dose'] as String?,
        vaccinatedOn: json['vaccinated_on'] as String?,
        notes: json['notes'] as String?,
      );
    }).toList();
  }

  Future<HealthItem> addItemAsync(
    HealthListType type,
    String name, {
    String? reaction,
    String? severity,
    String? dosage,
    String? frequency,
    String? diagnosedOn,
    String? startedOn,
    String? endedOn,
    String? dose,
    String? vaccinatedOn,
    String? notes,
  }) async {
    final table = _tableMap[type]!;
    final json =
        await api.post(
              '/api/v1/health/$table',
              data: {
                'name': name,
                if (reaction != null) 'reaction': reaction,
                if (severity != null) 'severity': severity,
                if (dosage != null) 'dosage': dosage,
                if (frequency != null) 'frequency': frequency,
                if (diagnosedOn != null) 'diagnosed_on': diagnosedOn,
                if (startedOn != null) 'started_on': startedOn,
                if (endedOn != null) 'ended_on': endedOn,
                if (dose != null) 'dose': dose,
                if (vaccinatedOn != null) 'vaccinated_on': vaccinatedOn,
                if (notes != null) 'notes': notes,
              },
            )
            as Map<String, dynamic>;
    return HealthItem(
      id: json['id'] as String,
      label: json['name'] as String? ?? name,
      reaction: json['reaction'] as String?,
      severity: json['severity'] as String?,
      dosage: json['dosage'] as String?,
      frequency: json['frequency'] as String?,
      diagnosedOn: json['diagnosed_on'] as String?,
      startedOn: json['started_on'] as String?,
      endedOn: json['ended_on'] as String?,
      dose: json['dose'] as String?,
      vaccinatedOn: json['vaccinated_on'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Future<void> deleteItem(HealthListType type, String id) async {
    final table = _tableMap[type]!;
    await api.delete('/api/v1/health/$table/$id');
  }
}
