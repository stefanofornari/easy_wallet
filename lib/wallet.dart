import 'package:big_decimal/big_decimal.dart';

class EasyWallet {
  final String address;

  BigDecimal balance;

  EasyWallet(this.address) : balance = BigDecimal.parse("0.0");
}
