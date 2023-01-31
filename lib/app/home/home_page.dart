import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/app/view/app.dart';

import '../../search/search.dart';

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
        return GoRouter.of(context).go('/library');
      case 1:
        if (location == '/home') {
          return SearchFormPage.go(context);
        }
        return GoRouter.of(context).go('/home');
      case 2:
        return GoRouter.of(context).go('/community');
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).location;

    if (location.startsWith('/details')) {
      if (prevLocation == '/library') return 0;
      prevLocation = location;
      return 1;
    }
    if (location.startsWith('/library')) {
      prevLocation = location;
      return 0;
    }
    if (location.startsWith('/home') || location.startsWith('/search')) {
      prevLocation = location;
      return 1;
    }
    if (location.startsWith('/community')) {
      prevLocation = location;

      return 2;
    }
    prevLocation = location;
    return 1;
  }
}
