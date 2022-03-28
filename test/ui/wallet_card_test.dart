import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/ui/wallet_app.dart';

import 'testing_utils.dart';

void main() {

  testWidgets('delete card action', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    home.state.controller + EasyWallet(WALLET1);
    await tester.pumpAndSettle();

    var button = find.descendant(of: find.byKey(Key(WALLET1)), matching: find.byIcon(Icons.delete));
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);
  });
}