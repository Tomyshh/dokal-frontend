import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

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
    emit(state.copyWith(status: SearchStatus.loading, locationUnavailable: false));
    double? lat;
    double? lng;
    bool locationUnavailable = false;
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (enabled) {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 8),
            ),
          );
          lat = pos.latitude;
          lng = pos.longitude;
        } else {
          locationUnavailable = true;
        }
      } else {
        locationUnavailable = true;
      }
    } catch (_) {
      locationUnavailable = true;
    }
    final res = await _searchPractitioners(state.query, lat: lat, lng: lng);
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
                locationUnavailable: locationUnavailable,
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
