import 'package:easy_wallet/resources/constants.dart';
import "package:flutter/material.dart";

import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/wallet_manager.dart';
import 'package:easy_wallet/easy_wallet.dart';

class WalletListController extends ValueNotifier<List<EasyWallet>> {

  late WalletManager walletManager;

  WalletListController() : super(<EasyWallet>[]) {
    walletManager = WalletManager(
      (ew.preferences[KEY_CFG_ENDPOINT] ?? "") + "/" + (ew.preferences[KEY_CFG_APPKEY] ?? "")
    );
  }


  WalletListController operator +(EasyWallet wallet) {
    value.add(wallet); notifyListeners();

    return this;
  }

  WalletListController operator -(String address) {
    final int l = value.length;
    value.removeWhere((e) {
      return (e.address == address);
    });

    if (value.length != l) {
      notifyListeners();
    }

    return this;
  }

  Future<void> retrieveBalance() async {
    for (EasyWallet w in value) {
      await walletManager.balance(w);
      notifyListeners();
    }
  }

  bool isValidAddress(String address) {
    return !value.any((element) {
      return element.address == address;
    });
  }
}