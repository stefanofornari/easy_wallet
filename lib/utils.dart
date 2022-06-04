import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:hex/hex.dart';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;

import 'package:easy_wallet/easy_wallet.dart';

@visibleForTesting
bool UTILS_TEST = false;

bool isWalletAddressValid(String address) {
  final RegExp regexp = RegExp("([0-9a-fA-F]){40}");

  return regexp.hasMatch(address);
}

bool isValidMnemonic(String mnemonic) {
  return bip39.validateMnemonic(mnemonic);
}


/**
  WARNING: this function can take a long time: it goes through all keys 
  associated to the derivated path "m/44'/60'/0'/0" of the given mnemonic
  to look for the given address.
*/
String? mnemonicToPrivateKey(String mnemonic, String address) {
  //
  // See note for mnemonicToPrivateKey
  //
  final int UINT31_MAX = (!UTILS_TEST)? 2147483647: 20; // 2^31 - 1 or 20 under testing

  if (!isValidMnemonic(mnemonic)) {
    return null;
  }

  if (!isWalletAddressValid(address)) {
    return null;
  }

  String seed = bip39.mnemonicToSeedHex(mnemonic);
  
  bip32.BIP32 node = 
    bip32.BIP32.fromSeed(Uint8List.fromList(HEX.decode(seed)));
    
    bip32.BIP32 child = node.derivePath("m/44'/60'/0'/0");

    for (int i=0; i<UINT31_MAX; ++i) {
      bip32.BIP32 k = child.derive(i);
      String p = HEX.encode(k.privateKey!.toList());
      String a = EasyWallet.fromPrivateKey(p).address;
      if (a.substring(2) == address) {
        return p;
      }
    }

    return null;
}
