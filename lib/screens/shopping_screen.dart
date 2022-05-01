import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poms/components/product_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/wallet_service.dart';

class ShoppingScreen extends StatefulWidget {
  final bool owned;
  const ShoppingScreen({Key? key, required this.owned}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  late Future<List<QueryDocumentSnapshot>> _products;

  Future<List<QueryDocumentSnapshot>> getProducts() async {
    List<QueryDocumentSnapshot> _result = [];
    String _user = FirebaseAuth.instance.currentUser!.uid;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String mnemonic = _prefs.getString('Mnemonic')!;
    final priKey = await WalletService.getPrivateKey(mnemonic);
    final pubKey = await WalletService.getPublicKey(priKey);
    final pub = pubKey.toString();

    try {
      QuerySnapshot query;
      if (widget.owned) {
        query = await FirebaseFirestore.instance
            .collection('products')
            .where('owner', isEqualTo: pub)
            .get();
      } else {
        query = await FirebaseFirestore.instance
            .collection('products')
            .where('owner', isNotEqualTo: pub)
            .get();
      }

      for (var element in query.docs) {
        debugPrint(element['owner']);
        _result.add(element);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('sorry couldn\'t fetch data'),
      ));
      debugPrint(error.toString());
      _result.clear();
    }

    return _result;
  }

  Future<void> refreshProducts() async {
    setState(() {
      _products = getProducts();
    });
  }

  @override
  void initState() {
    super.initState();
    _products = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _products,
      builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
              onRefresh: refreshProducts,
              child: snapshot.data!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return ProductCard(
                          id: snapshot.data![index].id,
                          name: snapshot.data![index]['name'],
                          description: snapshot.data![index]['description'],
                          ownerName: snapshot.data![index]['ownerName'],
                          price: snapshot.data![index]['price'],
                          status: snapshot.data![index]['status'],
                          isOwner: widget.owned,
                        );
                      }),
                      itemCount: snapshot.data!.length,
                    )
                  : const Center(
                      child: Text('Pull down to refresh'),
                    ));
          //  : const Center(child: Text('Pull to refresh'),), onRefresh: refreshProducts);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
