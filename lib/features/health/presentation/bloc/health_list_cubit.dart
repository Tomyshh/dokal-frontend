import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/health_item.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/usecases/get_health_list.dart';

part 'health_list_state.dart';

class HealthListCubit extends Cubit<HealthListState> {
  HealthListCubit({
    required HealthListType type,
    required GetHealthList getHealthList,
  }) : _type = type,
       _getHealthList = getHealthList,
       super(const HealthListState.initial());

  final HealthListType _type;
  final GetHealthList _getHealthList;

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
}
