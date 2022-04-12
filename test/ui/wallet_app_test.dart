import 'dart:convert' show json;
import 'package:file/file.dart';
import 'package:file/memory.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/wallet_manager.dart';
import "package:easy_wallet/resources/constants.dart";
import 'package:easy_wallet/ui/wallet_app.dart';

import '../stubs/wallet_manager_stub.dart';
import 'testing_utils.dart';

Future<void> _showDialog(WidgetTester tester) async {
  await tester.pumpWidget(EasyWalletApp());

  await tester.tap(find.byKey(KEY_ADD_WALLET));
  await tester.pumpAndSettle();
}


void main() {

  setUp(() {
    ew.fs = MemoryFileSystem.test();
    File configFile = ew.getConfigFile();

    configFile.createSync(recursive: true);
    
    configFile.writeAsStringSync("{}");
  });

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
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

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

  testWidgets('adding/removing a wallet updates the cards view', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    home.state.controller + EasyWallet(WALLET1);
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsOneWidget);
    expect(find.byKey(Key(WALLET1)), findsOneWidget);
    expect(findTextInCard(tester, Key(WALLET1), WALLET1), true);
    
    home.state.controller + EasyWallet(WALLET2);
    await tester.pump();
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byKey(Key(WALLET2)), findsOneWidget);
    expect(findTextInCard(tester, Key(WALLET2), WALLET2), true);

    home.state.controller - WALLET2;
    await tester.pump();
    expect(find.byType(Card), findsOneWidget);
    expect(find.byKey(Key(WALLET1)), findsOneWidget);
    expect(findTextInCard(tester, Key(WALLET1), WALLET1), true);
  });  

  testWidgets('refresh shows updated balance', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    //
    // add a couple of wallets
    //
    home.state.controller + EasyWallet(WALLET1) + EasyWallet(WALLET2);

    //
    // trigger refresh
    //
    await tester.tap(find.byKey(KEY_REFRESH)); await tester.pumpAndSettle();

    //
    // balances updated
    //
    expect(findTextInCard(tester, Key(WALLET1), "\n 18.424220187167293"), true);
    expect(findTextInCard(tester, Key(WALLET2), "\n 0.000000002853179621"), true);
  });

  testWidgets('refresh shows a message if connection error', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    //
    // add a wallet
    //
    home.state.controller + EasyWallet(WALLET1);

    //
    // trigger refresh
    //
    home.state.controller.walletManager = WalletManageWithStub("https://a.endpoint.io/PROJECTID1/SocketException");
    await tester.tap(find.byKey(KEY_REFRESH)); await tester.pump();

    //
    // balances updated
    //
    expect(find.text(ERR_NETWORK_ERROR, findRichText: true), findsOneWidget);
  });

  testWidgets('retrieves the current balance via walletManager', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    home.state.controller + EasyWallet(WALLET1);
  
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byKey(Key(WALLET1)), matching: find.text("\n 18.424220187167293", findRichText: true)), findsOneWidget);
  });

  testWidgets('+/- walltes updates the configuration', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);
    home.state.controller + EasyWallet(WALLET1);

    File configFile = ew.getConfigFile();
    var config = json.decoder.convert(
      configFile.readAsStringSync()
    );
    expect(config["wallets"].length, 1);
    expect(config["wallets"][0]["address"], WALLET1);
  });
  
}
