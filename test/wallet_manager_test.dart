import 'package:test/test.dart';

import 'package:big_decimal/big_decimal.dart';
import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/wallet_manager.dart';
import 'package:easy_wallet/wallet_exception.dart';

import 'stubs/wallet_manager_stub.dart';

const String WALLET1 = "0x00000000219ab540356cbb839cbe05303d7705fa";
const String WALLET2 = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";


void main() {

  test('create wallet manager', () {
    expect(WalletManager("https://mainnet.infura.io/v3/PROJECTID1").endpoint,
      "https://mainnet.infura.io/v3/PROJECTID1");
    expect(WalletManager("https://mainnet.infura.io/v3/PROJECTID2").endpoint,
              "https://mainnet.infura.io/v3/PROJECTID2");
  });

  test('get wallet balance', () async {
    EasyWallet w = EasyWallet(WALLET1);
    WalletManageWithStub wm = WalletManageWithStub("https://a.endpoint.io/v3/PROJECTID1");

    wm.argsMap = {
      WALLET1: "0x7baa706cf4a4220055045",
      WALLET2: "0x647DC0901C745DB420913"
    };

    await wm.balance(w);
    expect(w.balance, BigDecimal.parse("9343922000069000000000069"));

    w = EasyWallet(WALLET2);
    await wm.balance(w);
    expect(w.balance, BigDecimal.parse("7592901870686660123035923"));
  });

  test('turn network errors into WalletException', () async {
    WalletManageWithStub wm = WalletManageWithStub("https://a.endpoint.io/v3/PROJECT/SocketException");

    try {
      await wm.balance(EasyWallet(WALLET1));
    } on WalletException catch(e) {
      expect(e.message, ERR_NETWORK_ERROR);
      return;
    }
    fail("no WalletException");
 
  });

  test('turn http errors into WalletException', () async {
    WalletManageWithStub wm = WalletManageWithStub("https://a.endpoint.io/v3/PROJECT/HttpStatus/404");
    wm.argsMap = {
      WALLET1: "0x7baa706cf4a4220055045",
      WALLET2: "0x647DC0901C745DB420913"
    };

    try {
      await wm.balance(EasyWallet(WALLET1));
    } on WalletException catch(e) {
      expect(e.message, ERR_CONTENT_ERROR);
      return;
    }
    fail("no WalletException");
  });
}