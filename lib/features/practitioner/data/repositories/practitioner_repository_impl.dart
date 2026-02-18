import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../../reviews/domain/entities/review.dart';
import '../../domain/entities/practitioner_profile.dart';
import '../../domain/repositories/practitioner_repository.dart';
import '../datasources/practitioner_remote_data_source.dart';

class PractitionerRepositoryImpl implements PractitionerRepository {
  PractitionerRepositoryImpl({required this.remote});

  final PractitionerRemoteDataSourceImpl remote;

  @override
  Future<Either<Failure, PractitionerProfile>> getById(String id) async {
    try {
      final profile = await remote.getByIdAsync(id);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadPractitioner));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, String>>>> getSlots(
    String id, {
    required String from,
    required String to,
  }) async {
    try {
      final slots = await remote.getSlotsAsync(id, from: from, to: to);
      return Right(slots);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getReviews(
    String id, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final reviews = await remote.getReviewsAsync(
        id,
        limit: limit,
        offset: offset,
      );
      return Right(
        reviews
            .map(
              (Review r) => <String, dynamic>{
                'id': r.id,
                'appointment_id': r.appointmentId,
                'practitioner_id': r.practitionerId,
                'patient_id': r.patientId,
                'rating': r.rating,
                'created_at': r.createdAt,
                'comment': r.comment,
                'practitioner_reply': r.practitionerReply,
                'patient_name': r.patientName,
              },
            )
            .toList(),
      );
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }
}
