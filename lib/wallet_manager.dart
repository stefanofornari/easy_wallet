import 'dart:io';
import 'package:big_decimal/big_decimal.dart';
import 'package:http/http.dart';
import 'package:dart_web3/dart_web3.dart';

import 'easy_wallet.dart';
import 'wallet_exception.dart';

class WalletManager {
  final String endpoint;

  WalletManager(this.endpoint);

  Future<void> balance(EasyWallet wallet) async {
    var ethClient = Web3Client(endpoint, getHttpClient());

    try {
      EtherAmount balance = 
        await ethClient.getBalance(EthereumAddress.fromHex(wallet.address));
      
      wallet.balance = BigDecimal.fromBigInt(balance.getInWei);
    } on SocketException {
      throw WalletException("I could not reach the endpoind, please check the preferences or the connectivity");
    }

  }

  Client getHttpClient() {
    return Client();
  }
}
