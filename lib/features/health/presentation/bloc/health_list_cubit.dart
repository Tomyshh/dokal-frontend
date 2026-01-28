import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/health_item.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/usecases/add_health_item_demo.dart';
import '../../domain/usecases/get_health_list.dart';

part 'health_list_state.dart';

class HealthListCubit extends Cubit<HealthListState> {
  HealthListCubit({
    required HealthListType type,
    required GetHealthList getHealthList,
    required AddHealthItemDemo addHealthItemDemo,
  }) : _type = type,
       _getHealthList = getHealthList,
       _addHealthItemDemo = addHealthItemDemo,
       super(const HealthListState.initial());

  final HealthListType _type;
  final GetHealthList _getHealthList;
  final AddHealthItemDemo _addHealthItemDemo;

  Future<void> load() async {
    emit(state.copyWith(status: HealthListStatus.loading));
    final res = await _getHealthList(_type);
    res.fold(
      (f) => emit(
        state.copyWith(status: HealthListStatus.failure, error: f.message),
      ),
      (items) => emit(
        state.copyWith(
          status: HealthListStatus.success,
          items: items,
          error: null,
        ),
      ),
    );
  }

  Future<void> addDemo() async {
    final res = await _addHealthItemDemo(_type);
    res.fold(
      (f) => emit(
        state.copyWith(status: HealthListStatus.failure, error: f.message),
      ),
      (_) async => load(),
    );
  }
}
