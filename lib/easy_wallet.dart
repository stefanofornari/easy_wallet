import 'package:big_decimal/big_decimal.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:decimal/decimal.dart';

class EasyWallet {
  final String address;

  BigDecimal balance;

  EasyWallet(this.address) : balance = BigDecimal.parse("0.0");

  factory EasyWallet.fromPrivateKey(String key) {
    return EasyWallet(EthPrivateKey.fromHex(key).address.hex);
  }

  String get readableBalance {
    EtherAmount amount = EtherAmount.fromUnitAndValue(EtherUnit.wei, balance.intVal);
    return Decimal.parse(amount.getValueInUnit(EtherUnit.ether).toString()).toString();
  }

}
