import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../account/domain/entities/relative.dart';
import '../../../account/domain/entities/user_profile.dart';
import '../../../account/domain/usecases/add_relative_demo.dart';
import '../../../account/domain/usecases/get_profile.dart';
import '../../../account/domain/usecases/get_relatives.dart';
import '../../../../l10n/l10n_static.dart';

part 'booking_patients_state.dart';

class BookingPatientsCubit extends Cubit<BookingPatientsState> {
  BookingPatientsCubit({
    required GetProfile getProfile,
    required GetRelatives getRelatives,
    required AddRelativeDemo addRelativeDemo,
  }) : _getProfile = getProfile,
       _getRelatives = getRelatives,
       _addRelativeDemo = addRelativeDemo,
       super(const BookingPatientsState.initial());

  final GetProfile _getProfile;
  final GetRelatives _getRelatives;
  final AddRelativeDemo _addRelativeDemo;

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
          () => const UserProfile(id: '', fullName: '—', email: '—', city: '—'),
        ),
        relatives: relRes.getOrElse(() => const []),
        error: null,
      ),
    );
  }

  Future<void> addRelativeDemo() async {
    emit(state.copyWith(status: BookingPatientsStatus.loading));
    final res = await _addRelativeDemo();
    res.fold(
      (f) => emit(
        state.copyWith(status: BookingPatientsStatus.failure, error: f.message),
      ),
      (_) async => load(),
    );
  }
}
