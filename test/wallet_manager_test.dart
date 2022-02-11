import 'package:test/test.dart';

import 'package:easy_wallet/wallet.dart';
import 'package:easy_wallet/wallet_manager.dart';

void main() {
  test('construc_wallet_manager', () {
    expect(WalletManager("https://mainnet.infura.io/v3/PROJECTID1").endpoint,
      "https://mainnet.infura.io/v3/PROJECTID1");
    expect(WalletManager("https://mainnet.infura.io/v3/PROJECTID2").endpoint,
              "https://mainnet.infura.io/v3/PROJECTID2");
  });

  test('get_wallet_balance', () async {
    EasyWallet w = EasyWallet("0x00000000219ab540356cBB839Cbe05303d7705Fa");
    WalletManager wm = WalletManager("https://mainnet.infura.io/v3/PROJECTID1");

    print("Getting balance");
    await wm.balance(w);
    print("done");

    //print(balance.getValueInUnit(EtherUnit.ether));


  });
}
