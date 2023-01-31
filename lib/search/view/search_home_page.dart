import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/search/view/search_form_page.dart';

import '../models/search_filter.dart';

class SearchHomePage extends StatelessWidget {
  const SearchHomePage({super.key});

  static const path = '/home';
  static const name = 'home';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blue[200]!,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Search Home Page'),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => SearchFormPage.go(context),
              child: const Text('Search All'),
            ),
            OutlinedButton(
              onPressed: () =>
                  SearchFormPage.go(context, filter: {SearchFilter.movie}),
              child: const Text('Search Movie'),
            ),
            OutlinedButton(
              onPressed: () => SearchFormPage.go(context,
                  query: 'hello', filter: {SearchFilter.movie}),
              child: const Text('Search Movie'),
            ),
          ],
        ),
      ),
    );
  }
}
