part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class SearchUpdated extends SearchEvent {
  const SearchUpdated({required this.query, required this.filter});

  final String query;
  final Set<SearchFilter> filter;

  @override
  List<Object> get props => [query, filter];
}
