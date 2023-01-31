import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/app/app.dart';

import 'package:go_router_test/app/router/router.dart';

import '../../search/search.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final AppRouter _router;

  @override
  void initState() {
    _router = AppRouter(context.read<AppBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      routerConfig: _router.router,
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const path = '/login';
  static const name = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.green[100]!,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login Page'),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () =>
                    context.read<AppBloc>().add(const AppAuthenticated()),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  static const path = '/library';
  static const name = 'library';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Library Page'),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => context.go('/details'),
            child: const Text('Details Page'),
          ),
        ],
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  static const path = '/details';
  static const name = 'details';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey[300]!,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Details Page'),
            // const SizedBox(height: 20),
            // OutlinedButton(
            //   onPressed: () =>
            //       context.read<AppBloc>().add(const AppLogoutRequested()),
            //   child: const Text('Logout'),
            // ),
          ],
        ),
      ),
    );
  }
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  static const path = '/community';
  static const name = 'community';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Community Page'),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => context.go('/community/settings'),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const path = 'settings';
  static const name = 'settings';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Settings Page'),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () =>
                context.read<AppBloc>().add(const AppLogoutRequested()),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
