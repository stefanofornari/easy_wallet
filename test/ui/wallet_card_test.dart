import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/ui/wallet_app.dart';

void main() {
  testWidgets('delete a card', (WidgetTester tester) async {
    const String ADDRESS = "1234567890123456789012345678901234567890";

    await tester.pumpWidget(EasyWalletApp());

    EasyWalletHomePage home = tester.widget(find.byType(EasyWalletHomePage));

    home.state.addWallet(ADDRESS);
    await tester.pump();

    var button = find.descendant(of: find.byKey(Key(ADDRESS)), matching: find.byIcon(Icons.delete));
    expect(button, findsOneWidget);
/*
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);

    */
  });
}