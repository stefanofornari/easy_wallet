import 'dart:io';
import 'dart:convert' show json;
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:path/path.dart' as path;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/preferences.dart';

import 'ui/testing_utils.dart';


void _givenConfiguration(Preferences config) {
  ew.getConfigFile().writeAsStringSync(json.encoder.convert(config));
}

void main() {

  setUp(() {
    ew.fs = MemoryFileSystem.test();
    File configFile = ew.getConfigFile();
    configFile.createSync(recursive: true);
    configFile.writeAsStringSync("");
  });

  testWidgets('preferences directory default', (WidgetTester tester) async {
    expect(ew.APPDATA, "${Platform.environment["HOME"]}/.local/share");
  });

  testWidgets('get the preferences file', (WidgetTester tester) async {
    expect(ew.getConfigFile().path, "${ew.APPDATA}${path.separator}ste.easy_wallet${path.separator}preferences.json");
  });

  testWidgets('read configuration at startup', (WidgetTester tester) async {
    Preferences config = Preferences();
    config.endpoint = "https://first.end.point";
    config.appkey = "firstappkey";
    _givenConfiguration(config);

    ew.main();
    expect(ew.preferences.endpoint, config.endpoint);
    expect(ew.preferences.appkey, config.appkey);
    expect(ew.preferences.wallets, []);
    
    config.endpoint = "https://other.end.point";
    config.appkey = "anotherappkey";
    _givenConfiguration(config);

    ew.main();
    expect(ew.preferences.endpoint, config.endpoint);
    expect(ew.preferences.appkey, config.appkey);
    expect(ew.preferences.wallets, []);
  });

  testWidgets('empty preferences if no config file', (WidgetTester tester) async {
    ew.main();
    expect(ew.preferences.appkey, "");
    expect(ew.preferences.appkey, "");
    expect(ew.preferences.wallets, []);
  });

  testWidgets('get the preferences file', (WidgetTester tester) async {
    ew.main();
    expect(ew.preferences.appkey, "");
    expect(ew.preferences.appkey, "");
    expect(ew.preferences.wallets, []);
  });

  testWidgets('show wallets in preferencesfile', (WidgetTester tester) async {
    Preferences p = Preferences();
    p.wallets = [EasyWallet(WALLET1)];
    _givenConfiguration(p);
    
    ew.main();
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsOneWidget);
    expect(find.byKey(Key(WALLET1)), findsOneWidget);
  });
  
}