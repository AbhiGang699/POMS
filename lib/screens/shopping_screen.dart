import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: const Text('hello'),
          onTap: () => FirebaseAuth.instance.signOut(),
        ),
      ),
    );
  }
}
