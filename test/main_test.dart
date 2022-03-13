import 'dart:io';
import 'dart:convert' show json;
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:path/path.dart' as path;

import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/main.dart' as ew;
import 'package:easy_wallet/resources/constants.dart';


void _givenConfiguration(FileSystem fs, Map config) {
  File configDir = fs.file(path.join(Platform.environment["HOME"] ?? ".", ".local/share/ste.easy_wallet"));
  File configFile = fs.file(path.join(configDir.path, "preferences.json"));

  configFile.createSync(recursive: true);
  configFile.writeAsStringSync(json.encoder.convert(config));
}

void main() {

  testWidgets('preferences directory default', (WidgetTester tester) async {
    expect(ew.APPDATA, "${Platform.environment["HOME"]}/.local/share");
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
}