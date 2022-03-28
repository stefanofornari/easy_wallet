
import 'package:http/http.dart';

import 'package:easy_wallet/wallet_manager.dart';
import 'mock_client.dart';

class WalletManageWithStub extends WalletManager {
  WalletManageWithStub(endpoint) : super(endpoint);

  var argsMap = {};

  @override
  Client getHttpClient() {
    Client client = 
    MockClient((method, data) {
      if (method == "eth_getBalance") {
        if (data != null) {
          List args = data as List;

          print("$args");

          return argsMap[args.first];
        }
      }
      return "boh";
    });

    return client;
  }
}