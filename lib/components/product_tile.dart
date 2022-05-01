import 'dart:developer';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:poms/screens/product_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatelessWidget {
  final String name, description, ownerName, id, price;
  final bool isOwner;
  final int status;

  const ProductCard(
      {Key? key,
      required this.id,
      required this.name,
      required this.description,
      required this.ownerName,
      required this.price,
      required this.status,
      required this.isOwner})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetail(
                          product: ProductCard(
                              id: id,
                              name: name,
                              description: description,
                              ownerName: ownerName,
                              price: price,
                              status: status,
                              isOwner: isOwner),
                        )));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(name),
                subtitle: Text(description),
                trailing: Text(ownerName),
              ),
              isOwner
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Initiate Shipping'),
                          onPressed: status == 0
                              ? () async {
                                  var result = '';
                                  try {
                                    var temp = await BarcodeScanner.scan();
                                    result = temp.rawContent;
                                  } catch (e) {
                                    result = 'error';
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Error'),
                                    ));
                                    return;
                                  }
                                  if (result != 'Error' && result != '') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Not enough balance'),
                                    ));
                                  }
                                }
                              : () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Already in Transit'),
                                  ));
                                },
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Request Product'),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Not enough balance'),
                            ));
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
