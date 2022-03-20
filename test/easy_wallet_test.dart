import 'package:test/test.dart';

import 'package:big_decimal/big_decimal.dart';
import 'package:easy_wallet/easy_wallet.dart';

void main() {
  test('create wallet', () {
    EasyWallet w = EasyWallet("0x000102030405060708090A0B0C0D0E0F10111213");
    expect(w.address, "0x000102030405060708090A0B0C0D0E0F10111213");

    w = EasyWallet("0x00000000219ab540356cBB839Cbe05303d7705Fa");
    expect(w.address, "0x00000000219ab540356cBB839Cbe05303d7705Fa");
  });

  test('get and set wallet balance', () {
    EasyWallet w = EasyWallet("0x00000000219ab540356cBB839Cbe05303d7705Fa");
    expect(w.balance.toDouble(), 0.0);

    w.balance = BigDecimal.parse("10.0");
    expect(w.balance.toDouble(), 10.0);
  });

  //
  // Let's assume for now the wallent is a Ethereum wallet; in such a case
  // balance is stored in wei, which is  big integer. We then turn it into
  // a readable form using getValueInUnit() of EtherAmount. This will have
  // to change to support divverent crypto currencies.
  //
  test('approxmitated readable balance', () {
    EasyWallet w = EasyWallet("0x00000000219ab540356cBB839Cbe05303d7705Fa");
    w.balance = BigDecimal.parse("586016130000000000000");
    expect(w.readableBalance, "586.01613");

    w.balance = BigDecimal.parse("4289723044");
    expect(w.readableBalance, "0.000000004289723044");
  });
}
