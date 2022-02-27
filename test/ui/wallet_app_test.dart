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
    await tester.pumpWidget(EasyWalletApp());
    EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));

    home.state.addWallet("1234567890123456789012345678901234567890");
    await tester.pump();
    expect(find.byType(Card), findsOneWidget);

    home.state.addWallet("0123456789012345678901234567890123456789");
    await tester.pump();
    expect(find.byType(Card), findsNWidgets(2));

    home.state.removeWallet("0123456789012345678901234567890123456789");
    await tester.pump();
    expect(find.byType(Card), findsOneWidget);
  });
  
}
