import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poms/screens/shopping_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final String? email = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      body: Column(
        children: [
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(email!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Wallet'),
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Wallet'),
                        ));
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Show QR'),
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('QR'),
                        ));
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
          const ShoppingScreen(
            owned: true,
          ),
        ],
      ),
    );
  }
}
