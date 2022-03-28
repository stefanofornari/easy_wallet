import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/ui/wallet_app.dart';

import '../stubs/wallet_manager_stub.dart';

const String WALLET1 = "1234567890123456789012345678901234567890";
const String WALLET2 = "0123456789012345678901234567890123456789";

Future<EasyWalletHomePage> givenWlalletManagerStub(WidgetTester tester) async {
  await tester.pumpWidget(EasyWalletApp());
    
  //
  // prepare the wallet manager stub
  //
  EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));
  WalletManageWithStub wm = WalletManageWithStub("https://a.endpoint.io/v3/PROJECTID1");

  wm.argsMap = {
    "0x" + WALLET1: "0xffaffaa4ffaffaa4",
    "0x" + WALLET2: "0xaa1010e5"
  };
  home.state.controller.walletManager = wm;
  // ---

  return home;
}

bool findTextInCard(WidgetTester tester, Key key, String text) {
  var texts = tester.widgetList(
    find.descendant(of: find.byKey(key), matching: find.byType(RichText))
  ).iterator;
  while (texts.moveNext()) {
    RichText t = texts.current as RichText;
    print(t);
    if (t.text.toPlainText().contains(text)) {
      return true;
    }
  }

  return false;
}