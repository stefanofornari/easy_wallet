import 'package:test/test.dart';

import 'package:easy_wallet/utils.dart';
import 'package:easy_wallet/resources/constants.dart';

import 'testing_constants.dart';


void main() {

  setUp(() {
    UTILS_TEST = true;
  });

  tearDown(() {
    UTILS_TEST = false;
  });

  test('valid/invalid wallet address', () {
    expect(
      isWalletAddressValid("b24f4ad87c027f05c58a71eed50193364c1c4a22"),
      true
    );

    expect(
      isWalletAddressValid(ADDRESS2.substring(2)),
      true
    );

    expect(
      isWalletAddressValid(""),
      false
    );

    expect(
      isWalletAddressValid("b24f4ad87"),
      false
    );

    expect(
      isWalletAddressValid("b24f4ad87c027f05cX8a71eed50193364c1c4a22"),
      false
    );

  });

  test('mnemonic to private key', () async {
    expect(
      mnemonicToPrivateKey(LABEL_MNEMONIC_PHRASE_HINT, "b24f4ad87c027f05c58a71eed50193364c1c4a22"),
      "82b4cd6699cc1aee53b492598def7833a5ca8aae948f817c325548cb3e62c610"
    );

    //
    // TODO : use a earlier key or it takes too long or fail (see use of TEST = true)!
    //
    expect(
      mnemonicToPrivateKey(LABEL_MNEMONIC_PHRASE_HINT, "2650ff4250b48ac5fce3120d98e5e8cb0f53a46c"),
      "430d762b277c762939d093394d3f8401c7153950ecdd4af267317cf4c7a0930a"
    );

    expect(
      mnemonicToPrivateKey(LABEL_MNEMONIC_PHRASE_HINT, "aa9cf2c097c9d407a7ff46568d7e7ac36385639e"),
      null
    );
  });

  test('mnemonic to private key with invalid mnemonic', () async {
    expect(
      mnemonicToPrivateKey("", "4a9cf2c097c9d407a7ff46568d7e7ac36385639e"),
      null
    );

    expect(
      mnemonicToPrivateKey("an invalid mnemonic", "b24f4ad87c027f05c58a71eed50193364c1c4a22"),
      null
    );
  });

  test('mnemonic to private key with invalid address', () async {
    expect(
      mnemonicToPrivateKey(LABEL_MNEMONIC_PHRASE_HINT, ""),
      null
    );

    expect(
      mnemonicToPrivateKey(LABEL_MNEMONIC_PHRASE_HINT, "xxxf4ad87c027f05c58a71eed50193364c1c4a22"),
      null
    );
  });

  test('valid/invalid mnemonic', () async {
    expect(
      isValidMnemonic(""),
      false
    );

    expect(
      isValidMnemonic("an invalid mnemonic"),
      false
    );
  });


}
