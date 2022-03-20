import 'package:big_decimal/big_decimal.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:decimal/decimal.dart';

class EasyWallet {
  final String address;

  BigDecimal balance;

  String get readableBalance {
    EtherAmount amount = EtherAmount.fromUnitAndValue(EtherUnit.wei, balance.intVal);
    return Decimal.parse(amount.getValueInUnit(EtherUnit.ether).toString()).toString();
  }

  EasyWallet(this.address) : balance = BigDecimal.parse("0.0");
}
