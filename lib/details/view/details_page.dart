import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  /// Method for pushing to this route within the app.
  static void go(BuildContext context) => context.goNamed(DetailsPage.name);

  static const path = '/details';
  static const name = 'details';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey[300]!,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Details Page'),
          ],
        ),
      ),
    );
  }
}
