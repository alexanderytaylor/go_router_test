import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/details/detials.dart';
import 'package:go_router_test/search/bloc/search_bloc.dart';

import 'package:go_router_test/search/models/models.dart';

class SearchFormPage extends StatelessWidget {
  const SearchFormPage._({
    super.key,
    this.query = '',
    this.filter = allSearchFilters,
  });

  /// Constructor for use inside the [GoRouter].
  factory SearchFormPage.fromGoRouter({String? query, String? filter}) {
    return SearchFormPage._(
      query: query ?? '',
      filter: filter != null && filter.isNotEmpty
          ? filter.stringToFilter
          : allSearchFilters,
    );
  }

  /// Method for pushing to this route within the app.
  static void go(
    BuildContext context, {
    String? query,
    Set<SearchFilter>? filter,
  }) {
    context.goNamed(
      SearchFormPage.name,
      queryParams: {
        if (query != null && query.isNotEmpty) 'query': query,
        if (filter != null && filter.isNotEmpty)
          'filter': filter.filterToString,
      },
    );
  }

  static const path = '/search';
  static const name = 'search';

  final String query;
  final Set<SearchFilter> filter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBloc()..add(SearchUpdated(query: query, filter: filter)),
      child: const SearchFormView(),
    );
  }
}

class SearchFormView extends StatelessWidget {
  const SearchFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blue[400]!,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Search Page'),
              const SizedBox(height: 20),
              Text('query: ${state.query}'),
              const SizedBox(height: 5),
              Text('filter: ${state.filter}'),
              OutlinedButton(
                onPressed: () => DetailsPage.go(context),
                child: const Text('Details'),
              ),
            ],
          );
        },
      ),
    );
  }
}
