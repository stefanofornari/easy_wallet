import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/ui/wallet_list_controller.dart';

void main() {

  const String W1 = "1111111111111111111111111111111111111111";
  const String W2 = "2222222222222222222222222222222222222222";
  const String W3 = "3333333333333333333333333333333333333333";
  
  test('create wallet controller', () {
    expect(WalletListController() is ValueNotifier, true);
    expect(WalletListController().value, []);
  });

  test('+/- walltes adds/removes the wollet from the value', () {
    WalletListController C = WalletListController();

    C + EasyWallet(W1);
    expect(C.value.length, 1);
    expect(C.value[0].address, W1);

    C + EasyWallet(W2) + EasyWallet(W3);
    expect(C.value.length, 3);
    expect(C.value[0].address, W1);
    expect(C.value[1].address, W2);
    expect(C.value[2].address, W3);

    C - W2;
    expect(C.value.length, 2);
    expect(C.value[0].address, W1);
    expect(C.value[1].address, W3);

    C - W1;
    expect(C.value.length, 1);
    expect(C.value[0].address, W3);

    C - "0000000000000000000000000000000000000000"; // does not exist
    expect(C.value.length, 1);
    expect(C.value[0].address, W3);

    C - W3;
    expect(C.value.length, 0);

  });

  test('call back the listeners upon changes', () {
    bool fired = false;
    WalletListController C = WalletListController();

    C.addListener(() { fired = true; });

    //
    // do not fire if empty
    //
    C - W1;
    expect(fired, false);
    
    C + EasyWallet(W1);
    expect(fired, true);
    
    fired = false; C - W1;
    expect(fired, true);

    C + EasyWallet(W1); fired = false;
    C - W2; // not in the list, do not fire a change
    expect(fired, false);
  });

  test('valid address is not in the list', () {
    WalletListController C = WalletListController();

    expect(C.isValidAddress(W1), true);
    C + EasyWallet(W1) + EasyWallet(W2) + EasyWallet(W3);
    expect(C.isValidAddress(W3), false);
    expect(C.isValidAddress(W2), false);
  });

}