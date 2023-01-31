import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router_test/search/search.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchUpdated>(_onSearchUpdated);
  }

  void _onSearchUpdated(SearchUpdated event, Emitter<SearchState> emit) {
    emit(SearchState(query: event.query, filter: event.filter));
  }
}
