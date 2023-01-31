part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.filter = allSearchFilters,
  });

  final String query;
  final Set<SearchFilter> filter;

  @override
  List<Object> get props => [query, filter];

  SearchState copyWith({
    String? query,
    Set<SearchFilter>? filter,
  }) {
    return SearchState(
      query: query ?? this.query,
      filter: filter ?? this.filter,
    );
  }
}
