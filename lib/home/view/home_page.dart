import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/community/community.dart';
import 'package:go_router_test/details/detials.dart';
import 'package:go_router_test/library/library.dart';

import 'package:go_router_test/search/search.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavBar(
      child: child,
    );
  }
}

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({super.key, required this.child});

  final Widget child;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  String prevLocation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shelves),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
        onTap: (int idx) => _onItemTapped(idx, context),
        currentIndex: _calculateSelectedIndex(context),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    final location = GoRouterState.of(context).location;
    switch (index) {
      case 0:
        return LibraryPage.go(context);
      case 1:
        if (location == SearchHomePage.path) {
          return SearchFormPage.go(context);
        }
        return SearchHomePage.go(context);
      case 2:
        return CommunityPage.go(context);
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).location;

    if (location.startsWith(DetailsPage.path)) {
      if (prevLocation == LibraryPage.path) return 0;
      prevLocation = location;
      return 1;
    }
    if (location.startsWith(LibraryPage.path)) {
      prevLocation = location;
      return 0;
    }
    if (location.startsWith(SearchHomePage.path) ||
        location.startsWith(SearchFormPage.path)) {
      prevLocation = location;
      return 1;
    }
    if (location.startsWith(CommunityPage.path)) {
      prevLocation = location;

      return 2;
    }
    prevLocation = location;
    return 1;
  }
}
