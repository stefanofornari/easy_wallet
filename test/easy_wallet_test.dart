import 'package:test/test.dart';

import 'package:big_decimal/big_decimal.dart';
import 'package:easy_wallet/easy_wallet.dart';

//
// Randomly generated address:
//
// var rng = Random.secure();
//    EthPrivateKey random = EthPrivateKey.createRandom(rng);
//    print(bytesToHex(random.privateKey));
//    print((await random.extractAddress()).hex);
//
const String PRIVATE_KEY1 = "008a2b2d41febc2bef749ecec009b86e5fa18753439b28789658eb7b411397abb6";
const String PRIVATE_KEY2 = "436804c64fea7474fc184d88f8219a3a72c6a9c26321e53babd3c4a8775ed88f";
const String ADDRESS1 = "0xc2a6927e5e2f27e5fc7d2611cb0246fb3151f034";
const String ADDRESS2 = "0x496ef9de509d5d4b3f48f33eb75e55c4b3005dc7";

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
  // Let's assume for now the wallet is a Ethereum wallet; in such a case
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

  //
  // From a private key
  //
  // TODO: 
  //   - saity check on the provided key
  test('read from private key', () async {
    expect(EasyWallet.fromPrivateKey(PRIVATE_KEY1).address, ADDRESS1);
    expect(EasyWallet.fromPrivateKey(PRIVATE_KEY2).address, ADDRESS2);
  });

  
}
