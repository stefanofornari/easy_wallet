import 'dart:io';
import 'dart:convert' show json;
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:path/path.dart' as path;

import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/resources/constants.dart';


void _givenConfiguration(FileSystem fs, Map config) {
  File configFile = ew.getConfigFile();

  configFile.createSync(recursive: true);
  configFile.writeAsStringSync(json.encoder.convert(config));
}

void main() {

  testWidgets('preferences directory default', (WidgetTester tester) async {
    expect(ew.APPDATA, "${Platform.environment["HOME"]}/.local/share");
  });

  testWidgets('get the preferences file', (WidgetTester tester) async {
    expect(ew.getConfigFile().path, "${ew.APPDATA}${path.separator}ste.easy_wallet${path.separator}preferences.json");
  });

  testWidgets('read configuration at startup', (WidgetTester tester) async {
    MemoryFileSystem fs = MemoryFileSystem.test();
    final config = {
      KEY_CFG_ENDPOINT: "https://first.end.point",
      KEY_CFG_APPKEY: "firstappkey"
    };
    _givenConfiguration(fs, config);

    ew.fs = fs;
    ew.main();
    
    config[KEY_CFG_ENDPOINT] = "https://other.end.point";
    config[KEY_CFG_APPKEY] = "anotherappkey";
    _givenConfiguration(fs, config);

    ew.fs = fs;
    ew.main();
    expect(ew.preferences, config);
  });

  testWidgets('empty preferences if no config file', (WidgetTester tester) async {
    MemoryFileSystem fs = MemoryFileSystem.test();
    
    ew.fs = fs;
    ew.main();
    expect(ew.preferences, {});
  });

  testWidgets('get the preferences file', (WidgetTester tester) async {
    MemoryFileSystem fs = MemoryFileSystem.test();
    
    ew.fs = fs;
    ew.main();
    expect(ew.preferences, {});
  });
}