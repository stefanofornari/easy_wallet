
import "package:flutter/material.dart";

import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/wallet_manager.dart';
import 'package:easy_wallet/easy_wallet.dart';

class WalletListController extends ValueNotifier<List<EasyWallet>> {

  late WalletManager walletManager;

  WalletListController() : super([]) {
    walletManager = WalletManager(
      ew.preferences.endpoint + "/" + ew.preferences.appkey
    );
  }

  WalletListController operator +(EasyWallet wallet) {
    value.add(wallet);
    walletManager.balance(wallet).whenComplete(() => notifyListeners());  // TODO: remove notifyListener

    _savePreferences();
    
    return this;
  }

  WalletListController operator -(String address) {
    final int len = value.length;
    value.removeWhere((e) {
      return (e.address == address);
    });

    if (value.length != len) {
      _savePreferences();
    }

    return this;
  }

  void updateWallet(EasyWallet wallet) {
    for (int i=0; i<value.length; ++i) {
      if (value[i].address == wallet.address) {
        value[i] = wallet;
        break;
      }
    }
    _savePreferences();
  }

  Future<void> retrieveBalance() async {
    for (EasyWallet w in value) {
      await walletManager.balance(w); notifyListeners(); // TODO: remove notifyListener
    }
  }

  bool isValidAddress(String address) {
    return !value.any((element) {
      return element.address == address;
    });
  }

  _savePreferences() {
    ew.preferences.wallets = value;
    ew.savePreferences();
  }
}