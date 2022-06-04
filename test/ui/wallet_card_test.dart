import 'package:file/file.dart';
import 'package:file/memory.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/ui/wallet_app.dart';

import '../testing_constants.dart';
import 'testing_utils.dart';

void main() {

  setUp(() {
    ew.fs = MemoryFileSystem.test();
    File configFile = ew.getConfigFile();

    configFile.createSync(recursive: true);
    
    configFile.writeAsStringSync("{}");
  });

  testWidgets('UI elements', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    home.state.controller + EasyWallet(WALLET1);
    tester.state(find.byType(EasyWalletHomePage)).setState(() {}); await tester.pump();

    var card = find.byKey(Key(WALLET1));
    expect(
      find.descendant(of: card, matching: find.byIcon(Icons.delete)), 
      findsOneWidget
    );
    expect(
      find.descendant(of: card, matching: find.byIcon(Icons.lock_open)), 
      findsOneWidget
    );
  });

  testWidgets('delete card action', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    home.state.controller + EasyWallet(WALLET1);
    tester.state(find.byType(EasyWalletHomePage)).setState(() {}); await tester.pump();

    var button = find.descendant(of: find.byKey(Key(WALLET1)), matching: find.byIcon(Icons.delete));
    
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('private key button tap opens the edit parivate key dialog', (WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    home.state.controller + EasyWallet(WALLET1);
    tester.state(find.byType(EasyWalletHomePage)).setState(() {}); await tester.pump();

    var button = find.descendant(of: find.byKey(Key(WALLET1)), matching: find.byIcon(Icons.lock_open));
    
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
  });
}