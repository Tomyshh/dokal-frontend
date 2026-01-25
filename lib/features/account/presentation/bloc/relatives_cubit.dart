import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/relative.dart';
import '../../domain/usecases/add_relative_demo.dart';
import '../../domain/usecases/get_relatives.dart';

part 'relatives_state.dart';

class RelativesCubit extends Cubit<RelativesState> {
  RelativesCubit({
    required GetRelatives getRelatives,
    required AddRelativeDemo addRelativeDemo,
  })  : _getRelatives = getRelatives,
        _addRelativeDemo = addRelativeDemo,
        super(const RelativesState.initial());

  final GetRelatives _getRelatives;
  final AddRelativeDemo _addRelativeDemo;

  Future<void> load() async {
    emit(state.copyWith(status: RelativesStatus.loading));
    final res = await _getRelatives();
    res.fold(
      (f) => emit(state.copyWith(status: RelativesStatus.failure, error: f.message)),
      (items) => emit(state.copyWith(status: RelativesStatus.success, items: items, error: null)),
    );
  }

  Future<void> addDemo() async {
    final res = await _addRelativeDemo();
    res.fold(
      (f) => emit(state.copyWith(status: RelativesStatus.failure, error: f.message)),
      (_) async => load(),
    );
  }
}

