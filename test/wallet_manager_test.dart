import 'dart:convert';

import 'package:test/test.dart';

import 'package:big_decimal/big_decimal.dart';
import 'package:easy_wallet/wallet.dart';
import 'package:easy_wallet/wallet_manager.dart';
import 'package:http/http.dart';

import 'mock_client.dart';

const String WALLET1 = "0x00000000219ab540356cBB839Cbe05303d7705Fa";
const String WALLET2 = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";


void main() {
  
  test('construc_wallet_manager', () {
    expect(WalletManager("https://mainnet.infura.io/v3/PROJECTID1").endpoint,
      "https://mainnet.infura.io/v3/PROJECTID1");
    expect(WalletManager("https://mainnet.infura.io/v3/PROJECTID2").endpoint,
              "https://mainnet.infura.io/v3/PROJECTID2");
  });

  test('get_wallet_balance', () async {
    EasyWallet w = EasyWallet(WALLET1);
    WalletManager wm = WalletManageWithMock("https://a.endpoint.io/v3/PROJECTID1");

    await wm.balance(w);
    expect(w.balance, BigDecimal.parse("9343922000069000000000069"));

    w = EasyWallet(WALLET2);
    await wm.balance(w);
    expect(w.balance, BigDecimal.parse("7592901870686660123035923"));
  });
}

// -------------------------------------------------------- WalletManageWithMock

class WalletManageWithMock extends WalletManager {
  WalletManageWithMock(endpoint) : super(endpoint);

  @override
  Client getHttpClient() {
    return MockClient((method, data) {
      if (method == "eth_getBalance") {
        if (data != null) {
          List args = data as List;
          if (args.first as String == WALLET1.toLowerCase()) {
            return "0x7baa706cf4a4220055045";
          } else if (args.first as String == WALLET2.toLowerCase()) {
            return "0x647DC0901C745DB420913";
          }
        }
      }
      return "boh";
    });
  }
}
