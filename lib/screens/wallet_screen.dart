import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/credentials.dart';

import '../helper/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late String pub;
  late String pri;
  late BigInt bal;

  Future<void> getWalletDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String mnemonic = _prefs.getString('Mnemonic')!;
    pri = await WalletService.getPrivateKey(mnemonic);
    var pk = await WalletService.getPublicKey(pri);
    pub = pk.toString();
    var net = WalletService().getNetworkProvider();
    var result = await net.getBalance(pk);
    bal = result.getInWei;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: FutureBuilder(
          future: getWalletDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var b = bal.toDouble();
              b = b / pow(10, 18);
              return Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    b.toStringAsPrecision(3) + 'Eth',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Public Key: ' + pub,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
