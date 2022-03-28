import 'dart:io';

import 'package:easy_wallet/resources/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../stubs/wallet_manager_stub.dart';

import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/wallet_manager.dart';
import 'package:easy_wallet/ui/wallet_list_controller.dart';

void main() {

  const String W1 = "1111111111111111111111111111111111111111";
  const String W2 = "2222222222222222222222222222222222222222";
  const String W3 = "3333333333333333333333333333333333333333";

  WalletManageWithStub wm = WalletManageWithStub("https://a.endpoint.io/v3/PROJECTKEY1");;
  WalletListController C = WalletListController();

  setUp(() {
    ew.preferences = const {
      KEY_CFG_ENDPOINT: "https://a.endpoint.io/v3",
      KEY_CFG_APPKEY: "PROJECTKEY1"
    };
    wm = WalletManageWithStub("https://a.endpoint.io/v3/PROJECTKEY1");;
    C = WalletListController();
    wm.argsMap = {
      "0x" + W1: "0xffaffaa4",
      "0x" + W2: "0xaa1010e5",
      "0x" + W3: "0x00000000"
    };
    C.walletManager = wm;
  });
  
  test('create wallet controller', () {
    expect(WalletListController() is ValueNotifier, true);
    expect(WalletListController().value, []);
    expect(WalletListController().walletManager is WalletManager, true);
  });

  test('+/- walltes adds/removes the wallet from the value', () {
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