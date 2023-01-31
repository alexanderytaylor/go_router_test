import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/settings/settings.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  /// Method for pushing to this route within the app.
  static void go(BuildContext context) => context.goNamed(CommunityPage.name);

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
            onPressed: () => SettingsPage.go(context),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
