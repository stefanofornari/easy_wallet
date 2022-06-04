import 'package:easy_wallet/resources/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/ui/mnemonic_phrase_editing_controller.dart';

import '../testing_constants.dart';

void main() {

  test("invalid if less not 12 words", () {
    final MnemonicEditingController c = MnemonicEditingController();

    c.text = ""; expect(c.isValidMnemonicPhrase(), false);
    c.text = "one two three"; expect(c.isValidMnemonicPhrase(), false);
    c.text = LABEL_MNEMONIC_PHRASE_HINT; expect(c. isValidMnemonicPhrase(), true);
  });


  test("valid private key from mnemonic phrase", () {
    final MnemonicEditingController c = MnemonicEditingController();

    c.text = LABEL_MNEMONIC_PHRASE_HINT;
    expect(c.privateKey(ADDRESS3.substring(2)), PRIVATE_KEY3);
  });
}