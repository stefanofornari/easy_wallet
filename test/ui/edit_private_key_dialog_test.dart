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
    await tester.pumpAndSettle();

    var button = find.descendant(of: find.byKey(Key(ADDRESS3.substring(2))), matching: find.byIcon(Icons.lock_open));
    
    await tester.tap(button);
    await tester.pumpAndSettle();

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
    await _showDialog(tester);

    var dialog = find.byType(Dialog);

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
    await _showDialog(tester);

    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.descendant(
        of: find.byType(Dialog), matching: find.text("CANCEL")));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('valid private key enables ok button', (WidgetTester tester) async {
    await _showDialog(tester);
    
    var textField = find.descendant(of: find.byType(Dialog), matching: find.byKey(KEY_PRIVATE_KEY));

    await tester.enterText(
      textField,
      PRIVATE_KEY3
    );
    await tester.pump();

    TextButton btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isTrue);
  });


  testWidgets('close the dialog when pressing ok', (WidgetTester tester) async {
    await _showDialog(tester);
    
    var textField = find.descendant(of: find.byType(Dialog), matching: find.byKey(KEY_PRIVATE_KEY));

    await tester.enterText(textField, PRIVATE_KEY3);
    await tester.pump();

    await tester.tap(find.descendant(of: find.byType(Dialog), matching: find.text("OK")));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('invalid private key invalidates ok button', (WidgetTester tester) async {
    await _showDialog(tester);
    
    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byKey(KEY_PRIVATE_KEY)),
      "00a"
    );
    await tester.pump();

    TextButton btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isFalse);

    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byKey(KEY_PRIVATE_KEY)),
      "0123456789001234567890012345678900123456789001234567890"  // not a private key
    );
    await tester.pump();

    btnok = tester.widget<TextButton>(find.ancestor(of: find.text("OK"), matching: find.byType(TextButton)));
    expect(btnok.enabled, isFalse);
  });

  testWidgets('disable private key if mnemonic phrase is not empty', (WidgetTester tester) async {
    await _showDialog(tester);

    TextField key = tester.widget<TextField>(find.byKey(KEY_PRIVATE_KEY));

    expect(key.enabled, isTrue);
    
    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byKey(KEY_MNEMONIC_PHRASE)),
      "a"
    );
    await tester.pump();
    
    key = tester.widget<TextField>(find.byKey(KEY_PRIVATE_KEY));
    expect(key.enabled, isFalse);

    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byKey(KEY_MNEMONIC_PHRASE)),
      ""
    );
    await tester.pump();

    key = tester.widget<TextField>(find.byKey(KEY_PRIVATE_KEY));
    expect(key.enabled, isTrue);
  });

  testWidgets('replace private key when mnemonic phrase is valid', (WidgetTester tester) async {
    await _showDialog(tester);

    TextField key = tester.widget<TextField>(find.byKey(KEY_PRIVATE_KEY));

    expect(key.enabled, isTrue);

    //
    // invalid passphrase
    //
    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byKey(KEY_MNEMONIC_PHRASE)),
      "one two three"
    );
    await tester.pump();
    
    expect(
      find.descendant(of: find.byType(Dialog), matching: find.text(PRIVATE_KEY3)),
      findsNothing
    );

    //
    // valid passphrase
    //
    await tester.enterText(
      find.descendant(of: find.byType(Dialog), matching: find.byKey(KEY_MNEMONIC_PHRASE)),
      LABEL_MNEMONIC_PHRASE_HINT
    );
    await tester.pump();
    
    expect(
      find.descendant(of: find.byType(Dialog), matching: find.text(PRIVATE_KEY3)),
      findsOneWidget
    );

  });
}