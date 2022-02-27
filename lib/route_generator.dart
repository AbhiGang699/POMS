import 'package:flutter/material.dart';
import 'package:poms/screens/home_screen.dart';
import 'components/sign_up_form.dart';
import 'components/sign_in_form.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case '/home_screen':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
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
