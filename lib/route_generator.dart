import 'package:flutter/material.dart';
import 'screens/sign_up_screen.dart';
import 'screens/sign_in_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}