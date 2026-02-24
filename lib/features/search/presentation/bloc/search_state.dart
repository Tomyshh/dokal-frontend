part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    required this.status,
    required this.query,
    required this.results,
    this.error,
    this.locationUnavailable = false,
  });

  const SearchState.initial()
    : status = SearchStatus.initial,
      query = '',
      results = const [],
      error = null,
      locationUnavailable = false;

  final SearchStatus status;
  final String query;
  final List<PractitionerSearchResult> results;
  final String? error;

  /// True si la localisation n'a pas pu être récupérée (permission refusée, erreur).
  /// Permet d'afficher un message "recherche sans tri par distance".
  final bool locationUnavailable;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<PractitionerSearchResult>? results,
    String? error,
    bool? locationUnavailable,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      error: error,
      locationUnavailable: locationUnavailable ?? this.locationUnavailable,
    );
  }

  @override
  List<Object?> get props => [status, query, results, error, locationUnavailable];
}
