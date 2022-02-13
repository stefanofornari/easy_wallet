import 'package:test/test.dart';

import 'package:big_decimal/big_decimal.dart';
import 'package:easy_wallet/wallet.dart';

void main() {
  test('create wallet', () {
    EasyWallet w = EasyWallet("0x000102030405060708090A0B0C0D0E0F10111213");
    expect(w.address, "0x000102030405060708090A0B0C0D0E0F10111213");

    w = EasyWallet("0x00000000219ab540356cBB839Cbe05303d7705Fa");
    expect(w.address, "0x00000000219ab540356cBB839Cbe05303d7705Fa");
  });

  test('get_and_set_wallet_balance', () {
    EasyWallet w = EasyWallet("0x00000000219ab540356cBB839Cbe05303d7705Fa");
    expect(w.balance.toDouble(), 0.0);

    w.balance = BigDecimal.parse("10.0");
    expect(w.balance.toDouble(), 10.0);
  });
}
