import 'package:flutter/material.dart';

import 'package:bip39/bip39.dart' as bip39;

import 'package:easy_wallet/utils.dart';

class MnemonicEditingController extends TextEditingController {

  bool isValidMnemonicPhrase() {
    return isValidMnemonic(value.text);
  }

  String? privateKey(String address) {
    if (!isValidMnemonicPhrase()) {
      return null;
    }

    return mnemonicToPrivateKey(value.text, address);
  }

}