import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/main.dart';
import 'package:easy_wallet/ui/wallet_app.dart';

import '../testing_constants.dart';
import '../stubs/wallet_manager_stub.dart';

Future<EasyWalletHomePage> givenWlalletManagerStub(WidgetTester tester) async {
  readPreferences();
  await tester.pumpWidget(EasyWalletApp());
    
  //
  // prepare the wallet manager stub
  //
  EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));
  WalletManageWithStub wm = WalletManageWithStub("https://a.endpoint.io/v3/PROJECTID1");

  wm.argsMap = {
    "0x" + WALLET1: "0xffaffaa4ffaffaa4",
    "0x" + WALLET2: "0xaa1010e5",
    ADDRESS1: "0xa0affaa4ffaffa50",
    ADDRESS3: "0xa0affaa4ffaffa50"
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
    if (t.text.toPlainText().contains(text)) {
      return true;
    }
  }

  return false;
}