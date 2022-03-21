import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/wallet_manager.dart';
import "package:easy_wallet/resources/constants.dart";
import 'package:easy_wallet/ui/wallet_app.dart';

import '../stubs/wallet_manager_stub.dart';

Future<void> _showDialog(WidgetTester tester) async {
  await tester.pumpWidget(EasyWalletApp());

  await tester.tap(find.byKey(KEY_ADD_WALLET));
  await tester.pumpAndSettle();
}

//
// TODO: replace with text()
bool _findTextInCard(WidgetTester tester, Key key, String text) {
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

void main() {

  const String WALLET1 = "1234567890123456789012345678901234567890";
  const String WALLET2 = "0123456789012345678901234567890123456789";

  testWidgets('main app has all ui elements', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());

    expect(find.byKey(KEY_ADD_WALLET), findsOneWidget);
    expect(find.byKey(KEY_REFRESH), findsOneWidget);

    expect(find.byType(Dialog), findsNothing);

  });

  testWidgets('show add wallet dialog', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());

    var button = find.byKey(KEY_ADD_WALLET);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('close add wallet dialog by cancel', (WidgetTester tester) async {
    await _showDialog(tester);
    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.descendant(
        of: find.byType(Dialog), matching: find.text("CANCEL")));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('valid address enables ok button', (WidgetTester tester) async {
    await _showDialog(tester);
    
    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)),
      WALLET1
    );
    await tester.pump();

    TextButton btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isTrue);
  });

  testWidgets('invalid address invalidates ok button', (WidgetTester tester) async {
    await _showDialog(tester);
    
    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)),
      "00A"
    );
    await tester.pump();

    TextButton btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isFalse);
  });

  testWidgets('existing address invalidates ok button', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());
    EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));

    home.state.controller + EasyWallet(WALLET1);

    await tester.pumpAndSettle();
    await _showDialog(tester);
    
    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)),
      WALLET1
    );
    await tester.pump();

    TextButton btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isFalse);
  });

  testWidgets('adding/remove a wallet updates the cards view', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());
    EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));

    home.state.controller + EasyWallet(WALLET1);
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsOneWidget);
    expect(find.byKey(Key(WALLET1)), findsOneWidget);
    expect(_findTextInCard(tester, Key(WALLET1), WALLET1), true);
    
    home.state.controller + EasyWallet(WALLET2);
    await tester.pump();
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byKey(Key(WALLET2)), findsOneWidget);
    expect(_findTextInCard(tester, Key(WALLET2), WALLET2), true);

    home.state.controller - WALLET2;
    await tester.pump();
    expect(find.byType(Card), findsOneWidget);
    expect(find.byKey(Key(WALLET1)), findsOneWidget);
    expect(_findTextInCard(tester, Key(WALLET1), WALLET1), true);
  });
  

  testWidgets('refresh shows updated balance', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());

    //
    // add a couple of wallets
    //
    EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));
    home.state.controller + EasyWallet(WALLET1) + EasyWallet(WALLET2);

    //
    // prepaare the stubbed WalletManager
    //
    WalletManageWithStub wm = WalletManageWithStub("https://a.endpoint.io/v3/PROJECTID1");

    wm.argsMap = {
      "0x" + WALLET1: "0xffaffaa4",
      "0x" + WALLET2: "0xaa1010e5"
    };
    home.state.controller.walletManager = wm;

    //
    // trigger refresh
    //
    await tester.tap(find.byKey(KEY_REFRESH)); await tester.pumpAndSettle();

    //
    // balances updated
    //
    expect(_findTextInCard(tester, Key(WALLET1), "\n 0.000000004289723044"), true);
    expect(_findTextInCard(tester, Key(WALLET2), "\n 0.000000002853179621"), true);
  });

  testWidgets('refresh shows a message if connection error', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());

    //
    // add a couple of wallets
    //
    EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));
    home.state.controller + EasyWallet(WALLET1);

    //
    // prepaare the stubbed WalletManager
    //
    WalletManageWithStub wm = WalletManageWithStub("https://a.endpoint.io/PROJECTID1/SocketException");

    home.state.controller.walletManager = wm;

    //
    // trigger refresh
    //
    await tester.tap(find.byKey(KEY_REFRESH)); await tester.pump();

    //
    // balances updated
    //
    expect(find.text(ERR_NETWORK_ERROR, findRichText: true), findsOneWidget);
  });


  
}
