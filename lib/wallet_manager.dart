import 'package:big_decimal/big_decimal.dart';
import 'package:http/http.dart';
import 'package:dart_web3/dart_web3.dart';

import 'easy_wallet.dart';

class WalletManager {
  final String endpoint;

  WalletManager(this.endpoint);

  Future<void> balance(EasyWallet wallet) async {
    var ethClient = Web3Client(endpoint, getHttpClient());

    EtherAmount balance = 
      await ethClient.getBalance(EthereumAddress.fromHex(wallet.address));
    
    wallet.balance = BigDecimal.fromBigInt(balance.getInWei);
  }

  Client getHttpClient() {
    return Client();
  }
}
