import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poms/components/product_tile.dart';

class ShoppingScreen extends StatefulWidget {
  final bool owned;
  const ShoppingScreen({Key? key, required this.owned}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  late Future<List<QueryDocumentSnapshot>> _products;

  Future<List<QueryDocumentSnapshot>> getProducts() async {
    print('in getproducts');
    List<QueryDocumentSnapshot> _result = [];
    String _user = FirebaseAuth.instance.currentUser!.uid;

    try {
      QuerySnapshot query;
      if (widget.owned) {
        query = await FirebaseFirestore.instance
            .collection('products')
            .where('owner', isEqualTo: _user)
            .get();
      } else {
        query = await FirebaseFirestore.instance
            .collection('products')
            .where('owner', isNotEqualTo: _user)
            .get();
      }

      for (var element in query.docs) {
        debugPrint(element['name']);
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
