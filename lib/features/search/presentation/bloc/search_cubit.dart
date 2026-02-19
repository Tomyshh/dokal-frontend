import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/practitioner_search_result.dart';
import '../../domain/usecases/search_practitioners.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required SearchPractitioners searchPractitioners})
    : _searchPractitioners = searchPractitioners,
      super(const SearchState.initial());

  final SearchPractitioners _searchPractitioners;
  Timer? _debounce;

  void setQuery(String q) {
    if (isClosed) return;
    emit(state.copyWith(query: q));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (isClosed) return;
      search();
    });
  }

  Future<void> search() async {
    if (isClosed) return;
    emit(state.copyWith(status: SearchStatus.loading));
    final res = await _searchPractitioners(state.query);
    if (isClosed) return;
    res.fold(
      (f) =>
          isClosed
              ? null
              : emit(
                  state.copyWith(
                    status: SearchStatus.failure,
                    error: f.message,
                  ),
                ),
      (items) => isClosed
          ? null
          : emit(
              state.copyWith(
                status: SearchStatus.success,
                results: items,
                error: null,
              ),
            ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
