import 'package:flutter/material.dart';

import 'package:easy_wallet/utils.dart';

class AddressEditingController extends TextEditingController {

  bool isValidAddress(String address) {
    return isWalletAddressValid(address);
  }

}