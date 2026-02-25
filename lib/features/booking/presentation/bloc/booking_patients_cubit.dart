import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../account/domain/entities/relative.dart';
import '../../../account/domain/entities/user_profile.dart';
import '../../../account/domain/usecases/get_profile.dart';
import '../../../account/domain/usecases/get_relatives.dart';
import '../../../../l10n/l10n_static.dart';

part 'booking_patients_state.dart';

class BookingPatientsCubit extends Cubit<BookingPatientsState> {
  BookingPatientsCubit({
    required GetProfile getProfile,
    required GetRelatives getRelatives,
  }) : _getProfile = getProfile,
       _getRelatives = getRelatives,
       super(const BookingPatientsState.initial());

  final GetProfile _getProfile;
  final GetRelatives _getRelatives;

  Future<void> load() async {
    emit(state.copyWith(status: BookingPatientsStatus.loading));
    final profRes = await _getProfile();
    final relRes = await _getRelatives();

    if (profRes.isLeft() || relRes.isLeft()) {
      final msg =
          profRes.fold((l) => l.message, (_) => null) ??
          relRes.fold((l) => l.message, (_) => null) ??
          l10nStatic.commonError;
      emit(state.copyWith(status: BookingPatientsStatus.failure, error: msg));
      return;
    }

    emit(
      state.copyWith(
        status: BookingPatientsStatus.success,
        me: profRes.getOrElse(
          () => UserProfile(
            id: '',
            fullName: l10nStatic.commonFallbackDash,
            email: l10nStatic.commonFallbackDash,
            city: l10nStatic.commonFallbackDash,
            role: 'patient',
          ),
        ),
        relatives: relRes.getOrElse(() => const []),
        error: null,
      ),
    );
  }

}
