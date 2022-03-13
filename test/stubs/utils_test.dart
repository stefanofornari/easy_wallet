import "package:test/test.dart";

import "package:easy_wallet/utils.dart";

void main() {
  test("exactly 40 characters", () {
    expect(isWalletAddressValid(""), false);
    expect(isWalletAddressValid("000111"), false);
    expect(isWalletAddressValid("000102030405060708090A0B0C0D0E0F10111213"), true);
  });

  test("no hex address is invalid", () {
    expect(isWalletAddressValid("000GHI030405060708090A0B0C0D0E0F10111213"), false);
  });
}

