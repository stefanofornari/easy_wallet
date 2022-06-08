import 'dart:convert' show json;
import 'package:easy_wallet/resources/constants.dart';

import 'easy_wallet.dart';

class _WalletPrefereces {
  late Map wallet;

  _WalletPrefereces(EasyWallet w) {
    wallet = {
      KEY_CFG_WALLET_ADDRESS: w.address,
      KEY_CFG_WALLET_PRIVATE_KEY: w.privateKey,
      KEY_CFG_WALLET_MNEMONIC: w.mnemonic
    };
  }

  Map toJson() => wallet;
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
    return Preferences.fromMap(json.decoder.convert(jsonString));
  }

  factory Preferences.fromMap(Map m) {
    Preferences p = Preferences();
    p.endpoint = m[KEY_CFG_ENDPOINT] ?? "";
    p.appkey = m[KEY_CFG_APPKEY] ?? "";
    p.wallets = [];
    for (Map w in m[KEY_CFG_WALLETS] ?? {}) {
      EasyWallet wallet = EasyWallet(w[KEY_CFG_WALLET_ADDRESS]);
      wallet.privateKey = w[KEY_CFG_WALLET_PRIVATE_KEY] ?? "";
      wallet.mnemonic = w[KEY_CFG_WALLET_MNEMONIC] ?? "";
      p.wallets.add(wallet);
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
    json[KEY_CFG_WALLETS] = list;

    return json;
   }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
}