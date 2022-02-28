import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import "package:easy_wallet/resources/constants.dart";
import 'package:easy_wallet/ui/wallet_app.dart';

Future<void> _showDialog(WidgetTester tester) async {
  await tester.pumpWidget(EasyWalletApp());

  await tester.tap(find.byKey(KEY_ADD_WALLET));
  await tester.pumpAndSettle();
}


void main() {
  testWidgets('empty home page', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());

    expect(find.text("No wallets yet..."), findsWidgets);
    expect(find.byKey(KEY_ADD_WALLET), findsOneWidget);
    //tester.widget(find.byKey(KEY_WALLET_LIST)
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('show add wallet dialog', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());

    expect(find.byType(Dialog), findsNothing);

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

  testWidgets('adding/remove a wallet updates the cards view', (WidgetTester tester) async {
    const String WALLET1 = "1234567890123456789012345678901234567890";
    const String WALLET2 = "0123456789012345678901234567890123456789";

    await tester.pumpWidget(EasyWalletApp());
    EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));

    home.state.addWallet(WALLET1);
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsOneWidget);
    expect(find.byKey(Key(WALLET1)), findsOneWidget);

    bool found = false;
    var texts = tester.widgetList(
      find.descendant(of: find.byKey(Key(WALLET1)), matching: find.byType(RichText))
    ).iterator;
    while (texts.moveNext()) {
      RichText t = texts.current as RichText;
      if (t.text.toPlainText().contains(WALLET1)) {
        found = true; 
      }
    }
    expect(found, true);

    home.state.addWallet(WALLET2);
    await tester.pump();
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byKey(Key(WALLET2)), findsOneWidget);
    found = false;
    texts = tester.widgetList(
      find.descendant(of: find.byKey(Key(WALLET2)), matching: find.byType(RichText))
    ).iterator;
    while (texts.moveNext()) {
      RichText t = texts.current as RichText;
      if (t.text.toPlainText().contains(WALLET2)) {
        found = true; 
      }
    }
    expect(found, true);

    home.state.removeWallet(WALLET2);
    await tester.pump();
    expect(find.byType(Card), findsOneWidget);
    expect(find.byKey(Key(WALLET1)), findsOneWidget);
    found = false;
    texts = tester.widgetList(
      find.descendant(of: find.byKey(Key(WALLET1)), matching: find.byType(RichText))
    ).iterator;
    while (texts.moveNext()) {
      RichText t = texts.current as RichText;
      if (t.text.toPlainText().contains(WALLET1)) {
        found = true; 
      }
    }
    expect(found, true);
  });
  
}
