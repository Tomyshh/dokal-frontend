import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/practitioner_profile.dart';
import '../../domain/usecases/get_practitioner_profile.dart';

part 'practitioner_state.dart';

class PractitionerCubit extends Cubit<PractitionerState> {
  PractitionerCubit({
    required GetPractitionerProfile getPractitionerProfile,
    required String practitionerId,
  }) : _getPractitionerProfile = getPractitionerProfile,
       super(PractitionerState.initial(practitionerId: practitionerId));

  final GetPractitionerProfile _getPractitionerProfile;

  Future<void> load() async {
    emit(state.copyWith(status: PractitionerStatus.loading));
    final res = await _getPractitionerProfile(state.practitionerId);
    res.fold(
      (f) => emit(
        state.copyWith(status: PractitionerStatus.failure, error: f.message),
      ),
      (profile) => emit(
        state.copyWith(
          status: PractitionerStatus.success,
          profile: profile,
          error: null,
        ),
      ),
    );
  }
}
