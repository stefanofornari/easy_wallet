import "package:flutter/material.dart";

import 'package:easy_wallet/easy_wallet.dart';

class WalletListController extends ValueNotifier<List<EasyWallet>> {
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
}