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
            builder: (context, state) => const DetailsErrorPage(),
            routes: [
              // TODO: add empty movie redirect
              GoRoute(
                path: 'movie/:movieId',
                builder: (context, state) => DetailsPage.movieFromGoRouter(
                  movieId: state.params['movieId'],
                ),
              ),
              // TODO: add empty tvShow redirect
              GoRoute(
                path: 'tv/:tvShowId',
                builder: (context, state) => DetailsPage.tvShowFromGoRouter(
                  tvShowId: state.params['tvShowId'],
                ),
              ),
              // TODO: add empty tvSeason redirect
              GoRoute(
                path: 'tv/:tvShowId/season/:seasonNo',
                builder: (context, state) => DetailsPage.tvSeasonFromGoRouter(
                  tvShowId: state.params['tvShowId'],
                  seasonNo: state.params['seasonNo'],
                ),
              ),
              // TODO: add empty tvEpisode redirect
              GoRoute(
                path: 'tv/:tvShowId/season/:seasonNo/episode/:episodeNo',
                builder: (context, state) => DetailsPage.tvEpisodeFromGoRouter(
                  tvShowId: state.params['tvShowId'],
                  seasonNo: state.params['seasonNo'],
                  episodeNo: state.params['episodeNo'],
                ),
              ),
              // TODO: add empty book redirect
              GoRoute(
                path: 'book/:bookId',
                builder: (context, state) => DetailsPage.bookFromGoRouter(
                  bookId: state.params['bookId'],
                  idType: state.queryParams['idType'],
                ),
              ),
              // TODO: add empty game redirect
              GoRoute(
                path: 'game/:gameId',
                builder: (context, state) {
                  return DetailsPage.gameFromGoRouter(
                    gameId: state.params['gameId'],
                  );
                },
              ),
              // TODO: add empty podcastShow redirect
              GoRoute(
                path: 'podcast/:podcastId',
                builder: (context, state) =>
                    DetailsPage.podcastShowFromGoRouter(
                  podcastShowId: state.params['podcastId'],
                  idType: state.queryParams['idType'],
                ),
              ),
              // TODO: add empty podcastEpisode redirect
              GoRoute(
                path: 'podcast/:podcastId/episode/:episodeId',
                builder: (context, state) =>
                    DetailsPage.podcastEpisodeFromGoRouter(
                  podcastShowId: state.params['podcastId'],
                  episodeId: state.params['episodeId'],
                  idType: state.queryParams['idType'],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: _guard,
    refreshListenable: GoRouterRefreshStream(appBloc.stream),
    observers: [MyNavObserver()],
  );

  FutureOr<String?> _guard(BuildContext context, GoRouterState state) {
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
