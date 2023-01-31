import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/app/app.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// Method for pushing to this route within the app.
  static void go(BuildContext context) => context.goNamed(SettingsPage.name);

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
