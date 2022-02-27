import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poms/screens/auth_screen.dart';
import 'package:poms/screens/home_screen.dart';
import 'package:poms/components/sign_in_form.dart';

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (userSnapshot.hasData) {
            return const HomeScreen();
          }
          return const AuthenticationScreen();
        });
  }
}
