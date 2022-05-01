import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hex/hex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poms/helper/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<StatefulWidget> createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController itemNumberController = TextEditingController();
  late String companyPrefix;

  Future<void> generateEPC(int itemNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDoc = await FirebaseFirestore.instance
        .collection(UserType.manufacturer.toString())
        .doc(widget.uid)
        .get();
    companyPrefix = userDoc.get('companyPrefix');
    var rng = Random();
    final serialNumber = rng.nextInt(1000);

    final hexString = itemNumber.toRadixString(16);
    final epcString =
        companyPrefix + hexString.toUpperCase() + serialNumber.toString();
    Navigator.pop(context, [epcString]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Product Info",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
              child: TextFormField(
                controller: nameController,
                key: const ValueKey('mail'),
                decoration: InputDecoration(
                  labelText: "Product Name",
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
              child: TextFormField(
                controller: descriptionController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
              child: TextFormField(
                controller: ownerNameController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Owner Name",
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
              child: TextFormField(
                controller: priceController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Price",
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
              child: TextFormField(
                controller: itemNumberController,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Item Number",
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: Center(
                  child: TextButton(
                      onPressed: () =>
                          generateEPC(int.parse(itemNumberController.text)),
                      child: const Text(
                        'Generate EPC',
                        style: TextStyle(fontSize: 20),
                      )),
                )),
          ],
        )),
      ),
    );
  }
}
