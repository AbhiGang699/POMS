import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poms/components/add_product.dart';
import 'package:poms/components/qr_generate.dart';
import 'package:poms/helper/constants.dart';
import 'package:poms/screens/shopping_screen.dart';
import 'package:poms/screens/wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/wallet_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String mode;

  Future<String> genPublicKey() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String mnemonic = _prefs.getString('Mnemonic')!;
    final priKey = await WalletService.getPrivateKey(mnemonic);
    final pubKey = await WalletService.getPublicKey(priKey);
    final pub = pubKey.toString();
    return pub;
  }

  Future<void> func() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? uType = prefs.getString('Mode');
    mode = uType!;
  }

  @override
  Widget build(BuildContext context) {
    final String? email = FirebaseAuth.instance.currentUser!.email;

    return FutureBuilder(
        future: func(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Column(
                children: [
                  Card(
                    color: Colors.amber,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(email!),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            if (mode == UserType.manufacturer.toString())
                              TextButton(
                                child: const Text('Add Product'),
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddProduct(uid: widget.uid)));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QRScreen(
                                                data: result[0],
                                                display: "Generated EPC : " +
                                                    "\n" +
                                                    result[0],
                                              )));
                                },
                              ),
                            TextButton(
                              child: const Text('Wallet'),
                              onPressed: () {
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(const SnackBar(
                                //   content: Text('Wallet'),
                                // ));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WalletScreen()));
                              },
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              child: const Text('Show QR'),
                              onPressed: () async {
                                final pub = await genPublicKey();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QRScreen(
                                              data: widget.uid,
                                              display:
                                                  'User\'s Unique Id\n' + pub,
                                            )));
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Owned Products',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const ShoppingScreen(
                    owned: true,
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
