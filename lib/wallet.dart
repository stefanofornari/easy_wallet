import 'package:big_decimal/big_decimal.dart';

class EasyWallet {
  final String address;

  BigDecimal _wallet;

  EasyWallet(this.address) : _wallet = BigDecimal.parse("0.0");

  BigDecimal get balance {
    return _wallet;
  }

  EasyWallet withBalance(BigDecimal balance) {
    _wallet = BigDecimal.parse("10.0");
    return this;
  }

}
