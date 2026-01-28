part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    required this.status,
    required this.query,
    required this.results,
    this.error,
  });

  const SearchState.initial()
    : status = SearchStatus.initial,
      query = '',
      results = const [],
      error = null;

  final SearchStatus status;
  final String query;
  final List<PractitionerSearchResult> results;
  final String? error;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<PractitionerSearchResult>? results,
    String? error,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, query, results, error];
}
