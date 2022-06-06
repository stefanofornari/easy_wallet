import 'package:easy_wallet/resources/constants.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/utils.dart';
import 'package:easy_wallet/ui/wallet_app.dart';

import '../testing_constants.dart';
import 'testing_utils.dart';

void main() {

  _showDialog(WidgetTester tester) async {
    EasyWalletHomePage home = await givenWlalletManagerStub(tester);

    EasyWallet wallet = EasyWallet(ADDRESS3.substring(2));

    home.state.controller + wallet;
    tester.state(find.byType(EasyWalletHomePage)).setState(() {}); await tester.pump();

    await tester.tap(
      find.descendant(of: find.byKey(Key(ADDRESS3.substring(2))), matching: find.byIcon(Icons.lock_open))
    ); await tester.pumpAndSettle();

    return find.byType(Dialog);
  }

  setUp(() {
    ew.fs = MemoryFileSystem.test();
    File configFile = ew.getConfigFile();

    configFile.createSync(recursive: true);
    
    configFile.writeAsStringSync("{}");

    UTILS_TEST = true; // make sure we use the test version of utils otherwise
                       // the operations with mnemonic phrase can take too long

  });

  testWidgets('edit private key UI', (WidgetTester tester) async {
    var dialog = await _showDialog(tester);

    expect(
      find.descendant(of: dialog, matching: find.textContaining(ADDRESS3.substring(2))),
      findsOneWidget
    );
    expect(
      find.descendant(of: dialog, matching: find.textContaining(LABEL_MNEMONIC_PHRASE_HINT)),
      findsOneWidget
    );
    expect(
      find.descendant(of: dialog, matching: find.textContaining(LABEL_PRIVATE_KEY_HINT)),
      findsOneWidget
    );
  });

  testWidgets('close add wallet dialog by cancel', (WidgetTester tester) async {
    var dialog = await _showDialog(tester);

    expect(dialog, findsOneWidget);
    await tester.tap(find.descendant(of: dialog, matching: find.text("CANCEL")));
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);
  });

  testWidgets('valid private key enables ok button', (WidgetTester tester) async {
    var dialog  = await _showDialog(tester);
    
    var textField = find.descendant(of: dialog, matching: find.byKey(KEY_PRIVATE_KEY));

    await tester.enterText(
      textField,
      PRIVATE_KEY3
    );
    await tester.pump();

    TextButton btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isTrue);
  });

  testWidgets('valid mnemonic phrase derives the proper private key', (WidgetTester tester) async {
    var dialog  = await _showDialog(tester);
    
    var textField = find.descendant(of: dialog, matching: find.byKey(KEY_MNEMONIC_PHRASE));
    await tester.enterText(
      textField,
      LABEL_MNEMONIC_PHRASE_HINT
    );
    await tester.pumpAndSettle();

    expect(find.descendant(of: dialog, matching: find.textContaining(PRIVATE_KEY3)), findsOneWidget);
  });

  testWidgets('close the dialog when pressing ok', (WidgetTester tester) async {
    var dialog = await _showDialog(tester);
    
    var textField = find.descendant(of: dialog, matching: find.byKey(KEY_PRIVATE_KEY));

    await tester.enterText(textField, PRIVATE_KEY3);
    await tester.pump();

    await tester.tap(find.descendant(of: dialog, matching: find.text("OK")));
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);
  });

  testWidgets('invalid private key invalidates ok button', (WidgetTester tester) async {
    var dialog = await _showDialog(tester);
    
    await tester.enterText(
      find.descendant(of: dialog, matching: find.byKey(KEY_PRIVATE_KEY)),
      "00a"
    );
    await tester.pump();

    TextButton btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isFalse);

    await tester.enterText(
      find.descendant(of: dialog, matching: find.byKey(KEY_PRIVATE_KEY)),
      "0123456789001234567890012345678900123456789001234567890"  // not a private key
    );
    await tester.pump();

    btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isFalse);
  });

  testWidgets('disable private key if mnemonic phrase is not empty', (WidgetTester tester) async {
    var dialog = await _showDialog(tester);

    TextField key = tester.widget<TextField>(find.byKey(KEY_PRIVATE_KEY));

    expect(key.enabled, isTrue);
    
    await tester.enterText(
      find.descendant(of: dialog, matching: find.byKey(KEY_MNEMONIC_PHRASE)),
      "a"
    );
    await tester.pump();
    
    key = tester.widget<TextField>(find.byKey(KEY_PRIVATE_KEY));
    expect(key.enabled, isFalse);

    await tester.enterText(
      find.descendant(of: dialog, matching: find.byKey(KEY_MNEMONIC_PHRASE)),
      ""
    );
    await tester.pump();

    key = tester.widget<TextField>(find.byKey(KEY_PRIVATE_KEY));
    expect(key.enabled, isTrue);
  });

  testWidgets('clear private key when mnemonic phrase is invalid', (WidgetTester tester) async {
    var dialog = await _showDialog(tester);

    var keyFinder = find.byKey(KEY_PRIVATE_KEY);
    TextField keyField = tester.widget<TextField>(keyFinder);
    await tester.enterText(keyFinder, "some text"); await tester.pump();

    //
    // invalid passphrase
    //
    await tester.enterText(
      find.descendant(of: dialog, matching: find.byKey(KEY_MNEMONIC_PHRASE)),
      "one two three"
    ); await tester.pump();
    
    expect(keyField.controller?.text, "");

    expect(
      find.descendant(of: dialog, matching: find.textContaining(LABEL_PRIVATE_KEY_HINT)),
      findsNothing
    );

    expect(
      find.descendant(of: dialog, matching: find.textContaining(LABEL_PRIVATE_KEY_MNEMONIC)),
      findsOneWidget
    );
  });

}