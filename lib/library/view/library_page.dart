import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/details/detials.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  /// Method for pushing to this route within the app.
  static void go(BuildContext context) => context.goNamed(LibraryPage.name);

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
            onPressed: () => DetailsPage.go(
              context,
              const MovieDetailsRequest(movieId: '1234'),
            ),
            child: const Text('Get movie details for id: 1234'),
          ),
        ],
      ),
    );
  }
}
