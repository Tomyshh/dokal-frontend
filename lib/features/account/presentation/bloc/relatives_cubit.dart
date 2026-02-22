import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/relative.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/add_relative_demo.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/get_relatives.dart';

part 'relatives_state.dart';

class RelativesCubit extends Cubit<RelativesState> {
  RelativesCubit({
    required GetRelatives getRelatives,
    required GetProfile getProfile,
    required AddRelativeDemo addRelativeDemo,
  }) : _getRelatives = getRelatives,
       _getProfile = getProfile,
       _addRelativeDemo = addRelativeDemo,
       super(const RelativesState.initial());

  final GetRelatives _getRelatives;
  final GetProfile _getProfile;
  final AddRelativeDemo _addRelativeDemo;

  Future<void> load() async {
    emit(state.copyWith(status: RelativesStatus.loading));
    final profileRes = await _getProfile();
    final relativesRes = await _getRelatives();

    final profile = profileRes.fold<UserProfile?>((_) => null, (p) => p);
    if (profileRes.isLeft() && relativesRes.isLeft()) {
      final msg = profileRes.fold((l) => l.message, (_) => null) ??
          relativesRes.fold((l) => l.message, (_) => null);
      emit(state.copyWith(status: RelativesStatus.failure, error: msg));
      return;
    }

    relativesRes.fold(
      (f) => emit(
        state.copyWith(
          status: RelativesStatus.failure,
          error: f.message,
          profile: profile,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: RelativesStatus.success,
          items: items,
          profile: profile,
          error: null,
        ),
      ),
    );
  }

  Future<void> addDemo() async {
    final res = await _addRelativeDemo();
    res.fold(
      (f) => emit(
        state.copyWith(status: RelativesStatus.failure, error: f.message),
      ),
      (_) async => load(),
    );
  }
}
