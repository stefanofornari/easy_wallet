import 'package:flutter/material.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/utils.dart';

class WalletEditingController extends TextEditingController {

  String key2address() {
    //
    // EasyWallet.fromPrivateKey fails with an assertion if the address is not
    // a valid one
    //
    try {
      return EasyWallet.fromPrivateKey(value.text).address.substring(2);
    } catch (e) {
      return "";
    }
  }

  bool isValidAddress(String address) {
    return isWalletAddressValid(address);
  }

}