import 'package:flutter/material.dart';

import 'package:easy_wallet/utils.dart';

class MnemonicEditingController extends TextEditingController {

  bool isValidMnemonicPhrase() {
    return isValidMnemonic(value.text);
  }

  String privateKey(String address) {
    String key = "";

    if (isValidMnemonicPhrase()) {
      key = mnemonicToPrivateKey(value.text, address) ?? "";
    }

    return key;
  }

}