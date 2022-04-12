import 'dart:convert' show json;
import 'package:easy_wallet/resources/constants.dart';

import 'easy_wallet.dart';

class _WalletPrefereces {
  late String address;

  _WalletPrefereces(EasyWallet w) {
    address = w.address;
  }

  Map toJson() => {
    "address": address
  };
}

class Preferences {
  String endpoint = "";
  String appkey = "";

  List<EasyWallet> wallets = [];

  Preferences() {
    endpoint = "";
    appkey = "";
    wallets = [];
  }

  factory Preferences.fromJson(String jsonString) {
    Map jsonMap = json.decoder.convert(jsonString);

    Preferences p = Preferences();
    p.endpoint = jsonMap[KEY_CFG_ENDPOINT] ?? "";
    p.appkey = jsonMap[KEY_CFG_APPKEY] ?? "";
    p.wallets = [];
    for (Map w in jsonMap[KEY_CFG_WALLETS] ?? {}) {
      p.wallets.add(EasyWallet(w[KEY_CFG_WALLET_ADDRESS]));
    }
    
    return p;
  }

  Map toJson() {
    Map json = {
      KEY_CFG_ENDPOINT: endpoint,
      KEY_CFG_APPKEY: appkey,
      KEY_CFG_WALLETS: []
    };

    List<_WalletPrefereces> list = [];
    for(EasyWallet w in wallets) {
      list.add(_WalletPrefereces(w));
    };
    json["wallets"] = list;

    return json;
   }
}