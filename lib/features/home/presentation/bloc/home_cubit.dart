import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/enable_home_history.dart';
import '../../domain/usecases/get_home_greeting_name.dart';
import '../../domain/usecases/get_home_history_enabled.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetHomeGreetingName getGreetingName,
    required GetHomeHistoryEnabled getHistoryEnabled,
    required EnableHomeHistory enableHistory,
  })  : _getGreetingName = getGreetingName,
        _getHistoryEnabled = getHistoryEnabled,
        _enableHistory = enableHistory,
        super(const HomeState.initial());

  final GetHomeGreetingName _getGreetingName;
  final GetHomeHistoryEnabled _getHistoryEnabled;
  final EnableHomeHistory _enableHistory;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final nameRes = await _getGreetingName();
    final histRes = await _getHistoryEnabled();

    String? error;
    String name = '—';
    bool enabled = false;

    nameRes.fold((f) => error ??= f.message, (v) => name = v);
    histRes.fold((f) => error ??= f.message, (v) => enabled = v);

    if (error != null) {
      emit(state.copyWith(status: HomeStatus.failure, error: error));
      return;
    }

    emit(
      state.copyWith(
        status: HomeStatus.success,
        greetingName: name,
        historyEnabled: enabled,
        error: null,
      ),
    );
  }

  Future<void> activateHistory() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final res = await _enableHistory();
    res.fold(
      (f) => emit(state.copyWith(status: HomeStatus.failure, error: f.message)),
      (_) => emit(
        state.copyWith(status: HomeStatus.success, historyEnabled: true, error: null),
      ),
    );
  }
}

