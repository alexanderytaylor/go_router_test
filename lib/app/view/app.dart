import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router_test/app/app.dart';

import 'package:go_router_test/router/router.dart';

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
    debugInvertOversizedImages = true;
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
