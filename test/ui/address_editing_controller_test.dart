import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/ui/address_editing_controller.dart';

void main() {

  const String W1 = "1111111111111111111111111111111111111111";
  const String W2 = "2222222222222222222222222222222222222222";
  const String W3 = "3333333333333333333333333333333333333333";
  
  test("exactly 40 characters", () {
    final WalletEditingController c = WalletEditingController();

    expect(c.isValidAddress(""), false);
    expect(c.isValidAddress("000111"), false);
    expect(c. isValidAddress("000102030405060708090A0B0C0D0E0F10111213"), true);
  });

  test("no hex address is invalid", () {
    final WalletEditingController c = WalletEditingController();

    expect(c.isValidAddress("000GHI030405060708090A0B0C0D0E0F10111213"), false);
  });
}