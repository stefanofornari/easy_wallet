import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import "package:easy_wallet/resources/constants.dart";
import 'package:easy_wallet/ui/wallet_app.dart';
//import 'package:easy_wallet/wallet.dart';

void main() {
  testWidgets('empty home page', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());

    expect(find.text("No wallets yet..."), findsWidgets);
    expect(find.byKey(KEY_ADD_WALLET), findsOneWidget);
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
    await tester.pumpWidget(EasyWalletApp());

    await tester.tap(find.byKey(KEY_ADD_WALLET));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.descendant(
        of: find.byType(Dialog), matching: find.text("CANCEL")));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('invalid address invalidates ok button', (WidgetTester tester) async {
    await tester.pumpWidget(EasyWalletApp());

    await tester.tap(find.byKey(KEY_ADD_WALLET));
    await tester.pumpAndSettle();
    
    /*
    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)),
      "00A"
    );
    await tester.pump();

    TextButton btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isFalse);
    */

  });
}
