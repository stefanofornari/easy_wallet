import 'dart:typed_data';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/resources/constants.dart';
import 'package:test/test.dart';

import 'package:hex/hex.dart';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;


void main() {

  test('mnemonic to extended key', () {
    expect(
      bip39.mnemonicToSeedHex("wild quiz always market robust board acid wild quiz always market robust board acid"), 
      "35347e2a0610d295f2c6651caa69f95cbff130008b19d5acf93828611e36750d8eeffc89d5ae2c6922a78bedd69e6c366eb131e5d6e33028edb45fac8a73483b"
    );

    expect(
      bip39.mnemonicToSeedHex("update elbow source spin squeeze horror world become oak assist bomb nuclear"), 
      "77e6a9b1236d6b53eaa64e2727b5808a55ce09eb899e1938ed55ef5d4f8153170a2c8f4674eb94ce58be7b75922e48e6e56582d806253bd3d72f4b3d896738a4"
    );

  });

  test('mnemonic to private key', () async {
    String seed = bip39.mnemonicToSeedHex(LABEL_MNEMONIC_PHRASE_HINT);
    print(seed);

    bip32.BIP32 node = 
      bip32.BIP32.fromSeed(Uint8List.fromList(HEX.decode(seed)));
    
    bip32.BIP32 child = node.derivePath("m/44'/60'/0'/0");
    print(child.toBase58());
    
    bip32.BIP32 k = child.derive(0); print(HEX.encode(k.privateKey!.toList()));
    expect(EasyWallet.fromPrivateKey(HEX.encode(k.privateKey!.toList())).address, "0xb24f4ad87c027f05c58a71eed50193364c1c4a22");

    k = child.derive(3824); print(HEX.encode(k.privateKey!.toList())); // random index
    expect(EasyWallet.fromPrivateKey(HEX.encode(k.privateKey!.toList())).address, "0x4a9cf2c097c9d407a7ff46568d7e7ac36385639e");
  });
}
