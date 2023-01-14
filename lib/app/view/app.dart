import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/app/app.dart';

import 'dart:developer' as dev;

// make app authentication

// test authentication

// test deep links

// test path and query params

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: AppView(),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppView extends StatelessWidget {
  AppView({super.key});

  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: HomeScreen.name,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final authStatus = context.read<AppBloc>().state.status;
      switch (authStatus) {
        case AppStatus.authenticated:
          return HomeScreen.path;
        case AppStatus.unauthenticated:
          return LoginScreen.path;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      routerConfig: _router,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const path = '/login';
  static const name = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const path = '/';
  static const name = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page'),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () =>
                  context.read<AppBloc>().add(const AppAuthenticated()),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
