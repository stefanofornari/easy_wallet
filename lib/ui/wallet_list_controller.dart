import "package:flutter/material.dart";

import 'package:big_decimal/big_decimal.dart';

import 'package:easy_wallet/wallet_manager.dart';
import 'package:easy_wallet/easy_wallet.dart';

class WalletListController extends ValueNotifier<List<EasyWallet>> {

  WalletManager walletManager = WalletManager("");

  WalletListController() : super(<EasyWallet>[]) {}

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