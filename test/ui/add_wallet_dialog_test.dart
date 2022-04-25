import 'package:file/file.dart';
import 'package:file/memory.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/main.dart' as ew;
import "package:easy_wallet/resources/constants.dart";
import 'package:easy_wallet/ui/add_wallet_dialog.dart';
import 'package:easy_wallet/ui/wallet_app.dart';

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

  testWidgets('add wallet dialog ui elements', (WidgetTester tester) async {
    await _showDialog(tester);

    var dialog = find.byType(Dialog);
    expect(
      find.descendant(of: dialog, matching: find.text("OK")
      ), findsOneWidget
    );
    expect(
      find.descendant(of: dialog, matching: find.text("CANCEL")
      ), findsOneWidget
    );
    expect(
      find.descendant(of: dialog, matching: find.byType(TextField)
      ), findsOneWidget
    );
    expect(
      find.descendant(of: dialog, matching: find.byType(Radio<AddWalletBy>)
      ), findsWidgets
    );
  });

   testWidgets('switch address/private key', (WidgetTester tester) async {
    await _showDialog(tester);

    //
    // default state
    //
    expect(find.text(LABEL_ADDRESS), findsOneWidget);
    Iterable<Radio<AddWalletBy>> radio = tester.widgetList<Radio<AddWalletBy>>(find.byType(Radio<AddWalletBy>));
    expect(radio.first.groupValue, AddWalletBy.address);
    expect(radio.last.groupValue, AddWalletBy.address);
    expect(find.text(LABEL_ADDRESS), findsOneWidget);
    expect(find.text(LABEL_ADDRESS_HINT), findsOneWidget);
    expect(find.text(LABEL_PRIVATE_KEY), findsNothing);
    expect(find.text(LABEL_PRIVATE_KEY_HINT), findsNothing);

    //
    // private key
    //
    await tester.tap(find.byKey(KEY_WALLET_BY_PRIVATE_KEY)); 
    await tester.pumpAndSettle();
    radio = tester.widgetList<Radio<AddWalletBy>>(find.byType(Radio<AddWalletBy>));
    expect(radio.first.groupValue, AddWalletBy.privateKey);
    expect(radio.last.groupValue, AddWalletBy.privateKey);
    expect(find.text(LABEL_PRIVATE_KEY), findsOneWidget);
    expect(find.text(LABEL_PRIVATE_KEY_HINT), findsOneWidget);
    expect(find.text(LABEL_ADDRESS), findsNothing);
    expect(find.text(LABEL_ADDRESS_HINT), findsNothing);

    //
    // back to address
    //
    await tester.tap(find.byKey(KEY_WALLET_BY_ADDRESS)); 
    await tester.pumpAndSettle();
    radio = tester.widgetList<Radio<AddWalletBy>>(find.byType(Radio<AddWalletBy>));
    expect(radio.first.groupValue, AddWalletBy.address);
    expect(radio.last.groupValue, AddWalletBy.address);
    expect(find.text(LABEL_ADDRESS), findsOneWidget);
    expect(find.text(LABEL_ADDRESS_HINT), findsOneWidget);
    expect(find.text(LABEL_PRIVATE_KEY), findsNothing);
    expect(find.text(LABEL_PRIVATE_KEY_HINT), findsNothing);
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
  
}
