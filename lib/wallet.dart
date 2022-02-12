import 'package:big_decimal/big_decimal.dart';

class EasyWallet {
  final String address;

  BigDecimal _balance;

  EasyWallet(this.address) : _balance = BigDecimal.parse("0.0");

  BigDecimal get balance {
    return _balance;
  }

  EasyWallet withBalance(BigDecimal balance) {
    _balance = balance;
    return this;
  }

}
