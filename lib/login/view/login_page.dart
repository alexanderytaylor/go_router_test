import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/app/app.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  /// Method for pushing to this route within the app.
  static void go(BuildContext context) => context.goNamed(LoginPage.name);

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
