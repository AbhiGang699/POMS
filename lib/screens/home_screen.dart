import 'dart:developer';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poms/components/product_tile.dart';
import 'package:poms/screens/product_detail.dart';
import 'package:poms/screens/shopping_screen.dart';
import 'package:poms/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  late String _uid;

  Future<String> _scan() async {
    try {
      final result = await BarcodeScanner.scan();
      return result.rawContent;
    } on PlatformException catch (_) {
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    List<Widget> _body = [
      const Center(
        child: ShoppingScreen(
          owned: false,
        ),
      ),
      Center(
        child: UserProfileScreen(uid: _uid),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('POMS'), actions: [
        IconButton(
            onPressed: () async {
              int value = -1;
              await showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Container(
                      height: 100,
                      child: Center(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              TextButton.icon(
                                onPressed: () {
                                  value = 0;
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.account_circle_outlined,
                                ),
                                label: const Text('User'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  value = 1;
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                    Icons.add_shopping_cart_outlined),
                                label: const Text('Product'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // behavior: HitTestBehavior.opaque,
                    );
                  });
              if (value == -1) {
                return;
              }
              var scanResult = await _scan();
              if (scanResult == 'error') {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Error')));
                return;
              }
              log(scanResult);
              if (value == 1) {
                var result = await FirebaseFirestore.instance
                    .collection('products')
                    .doc(scanResult)
                    .get();
                var product = ProductCard(
                    id: result.id,
                    name: result.get('name'),
                    description: result.get('description'),
                    ownerName: result.get('ownerName'),
                    price: result.get('price'),
                    status: result.get('status'),
                    isOwner: false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProductDetail(product: product)));
              }
              if (value == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Scaffold(
                              appBar: AppBar(),
                              body: UserProfileScreen(
                                uid: scanResult.trim(),
                              ),
                            )));
              }
            },
            icon: const Icon(Icons.qr_code)),
        IconButton(
            onPressed: (() async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              await _prefs.clear();
              FirebaseAuth.instance.signOut();
            }),
            icon: const Icon(Icons.exit_to_app))
      ]),
      body: _body[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        unselectedIconTheme: const IconThemeData(color: UIColors.black),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Feed",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "Profile",
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
