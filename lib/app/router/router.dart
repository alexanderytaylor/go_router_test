import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/app/app.dart';
import 'package:go_router_test/community/community.dart';
import 'package:go_router_test/details/detials.dart';
import 'package:go_router_test/home/view/home_page.dart';
import 'package:go_router_test/library/library.dart';
import 'package:go_router_test/login/login.dart';
import 'package:go_router_test/search/search.dart';
import 'package:go_router_test/settings/settings.dart';
import 'package:logging/logging.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

const _route = '/';

class AppRouter {
  AppRouter(this.appBloc);

  final AppBloc appBloc;

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    initialLocation: SearchHomePage.path,
    routes: [
      GoRoute(
        path: _route,
        redirect: (_, __) {
          if (appBloc.state.status == AppStatus.authenticated) {
            return SearchHomePage.path;
          } else {
            return LoginPage.path;
          }
        },
      ),
      GoRoute(
        path: LoginPage.path,
        name: LoginPage.name,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => HomePage(child: child),
        routes: [
          GoRoute(
            path: SearchHomePage.path,
            name: SearchHomePage.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchHomePage()),
          ),
          GoRoute(
            path: SearchFormPage.path,
            name: SearchFormPage.name,
            builder: (context, state) => SearchFormPage.fromGoRouter(
              query: state.queryParams['query'],
              filter: state.queryParams['filter'],
            ),
          ),
          GoRoute(
            path: LibraryPage.path,
            name: LibraryPage.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LibraryPage()),
          ),
          GoRoute(
            path: CommunityPage.path,
            name: CommunityPage.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CommunityPage()),
            routes: [
              GoRoute(
                path: SettingsPage.path,
                name: SettingsPage.name,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
          GoRoute(
            path: DetailsPage.path,
            name: DetailsPage.name,
            builder: (BuildContext context, GoRouterState state) =>
                const DetailsPage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authStatus = appBloc.state.status;
      final loggedIn = authStatus == AppStatus.authenticated;
      final loggingIn = state.subloc == LoginPage.path;
      if (!loggedIn) {
        return LoginPage.path;
      }

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn) {
        return SearchHomePage.path;
      }

      // no need to redirect at all
      return null;
    },
    refreshListenable: GoRouterRefreshStream(appBloc.stream),
    observers: [MyNavObserver()],
  );
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

/// The Navigator observer.
class MyNavObserver extends NavigatorObserver {
  /// Creates a [MyNavObserver].
  MyNavObserver() {
    log.onRecord.listen((LogRecord e) => debugPrint('$e'));
  }

  /// The logged message.
  final Logger log = Logger('MyNavObserver');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      log.info('didPush: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      log.info('didPop: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      log.info('didRemove: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      log.info('didReplace: new= ${newRoute?.str}, old= ${oldRoute?.str}');

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) =>
      log.info('didStartUserGesture: ${route.str}, '
          'previousRoute= ${previousRoute?.str}');

  @override
  void didStopUserGesture() => log.info('didStopUserGesture');
}

extension on Route<dynamic> {
  String get str => 'route(${settings.name}: ${settings.arguments})';
}
