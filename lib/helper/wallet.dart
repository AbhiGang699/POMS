import 'package:bip39/bip39.dart' as bip39;
import 'package:poms/helper/constants.dart';
import 'package:poms/helper/contract_parser.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';

class Wallet {
  Web3Client getNetworkProvider() {
    return Web3Client(apiUrl, Client());
  }

  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(master.key);
    return privateKey;
  }

  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    return address;
  }

  static Future<DeployedContract> get contract async {
    final DeployedContract contract =
        await ContractParser.fromAssets(contractAddress);
    return contract;
  }

  static Future<List> callFunction(
      {required String functionName, required List param}) async {
    final DeployedContract contract = await Wallet.contract;

    final function = contract.function(functionName);

    try {
      final List returnList = await Wallet()
          .getNetworkProvider()
          .call(contract: contract, function: function, params: param);
      return returnList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<bool> runTransaction(
      {required String functionName, required List parameter}) async {
    final DeployedContract deployedContract =
        await ContractParser.fromAssets(contractAddress);
    final Credentials credentials =
        // ignore: deprecated_member_use
        await Wallet()
            .getNetworkProvider()
            .credentialsFromPrivateKey(relayWallet);

    final function = deployedContract.function(functionName);
    try {
      await Wallet()
          .getNetworkProvider()
          .sendTransaction(
              credentials,
              Transaction.callContract(
                  maxGas: 1000000,
                  contract: deployedContract,
                  function: function,
                  parameters: parameter),
              fetchChainIdFromNetworkId: true)
          .then(
            (value) => print(value),
          )
          .catchError(
        (onError) {
          throw onError;
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
