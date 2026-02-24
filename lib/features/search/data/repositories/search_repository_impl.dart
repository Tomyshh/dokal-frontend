import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../../practitioner/domain/usecases/get_practitioner_slots.dart';
import '../../domain/entities/practitioner_search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({
    required this.remote,
    required this.getPractitionerSlots,
  });

  final SearchRemoteDataSourceImpl remote;
  final GetPractitionerSlots getPractitionerSlots;

  @override
  Future<Either<Failure, List<PractitionerSearchResult>>> search({
    required String query,
    double? lat,
    double? lng,
  }) async {
    try {
      var results = await remote.searchAsync(query, lat: lat, lng: lng);
      // Si le backend retourne vide avec une requête, tenter sans filtre
      // puis filtrer côté client (le backend peut être trop strict)
      if (results.isEmpty && query.trim().isNotEmpty) {
        final all = await remote.searchAsync('', lat: lat, lng: lng);
        final q = query.trim().toLowerCase();
        results = all.where((p) {
          return p.name.toLowerCase().contains(q) ||
              p.specialty.toLowerCase().contains(q) ||
              (p.address.toLowerCase().contains(q));
        }).toList();
      }
      results = await _enrichWithSlots(results);
      return Right(results);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadSearch));
    }
  }

  Future<List<PractitionerSearchResult>> _enrichWithSlots(
    List<PractitionerSearchResult> results,
  ) async {
    final needSlots = results.where((p) => p.nextAvailabilityLabel.isEmpty).toList();
    if (needSlots.isEmpty) return results;

    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: 14));
    final fromStr =
        '${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}';
    final toStr =
        '${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}';

    final futures = needSlots.map((p) => getPractitionerSlots(p.id, from: fromStr, to: toStr));
    final slotResults = await Future.wait(futures);

    final idToLabel = <String, String>{};
    for (var i = 0; i < needSlots.length; i++) {
      final p = needSlots[i];
      final nextLabel = slotResults[i].fold(
        (_) => '',
        (slots) {
          if (slots.isEmpty) return '';
          final first = slots.first;
          final date = first['slot_date'] ?? '';
          final start = first['slot_start'] ?? '';
          if (date.isEmpty || start.isEmpty) return '';
          final time = start.length >= 5 ? start.substring(0, 5) : start;
          return '$date $time';
        },
      );
      idToLabel[p.id] = nextLabel;
    }

    return results.map((p) {
      if (p.nextAvailabilityLabel.isNotEmpty) return p;
      final nextLabel = idToLabel[p.id] ?? '';
      return PractitionerSearchResult(
        id: p.id,
        name: p.name,
        specialty: p.specialty,
        address: p.address,
        sector: p.sector,
        nextAvailabilityLabel: nextLabel,
        city: p.city,
        distanceLabel: p.distanceLabel,
        avatarUrl: p.avatarUrl,
        languages: p.languages,
        distanceKm: p.distanceKm,
        availabilityOrder: p.availabilityOrder,
        rating: p.rating,
        reviewCount: p.reviewCount,
        priceMinAgorot: p.priceMinAgorot,
        priceMaxAgorot: p.priceMaxAgorot,
      );
    }).toList();
  }
}
