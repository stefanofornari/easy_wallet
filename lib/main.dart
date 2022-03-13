import 'dart:io';
import 'dart:math' as math;
import 'dart:convert' show json;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'package:easy_wallet/ui/wallet_app.dart';

final String APPDATA = Platform.environment["APPDATA"]
                       ?? (Platform.environment["HOME"] ?? ".") + path.separator + ".local" + path.separator + "share";

Map<String, String> preferences = const {};
late EasyWalletApp app;

FileSystem fs = const LocalFileSystem();

void main() {

  //
  // read the configuration and store it in memory
  //
  File configDir = fs.file(path.join(APPDATA, "ste.easy_wallet"));
  File configFile = fs.file(path.join(configDir.path, "preferences.json"));

  print("configFile: $configFile");

  if (!configFile.existsSync()) {
    preferences = {};
  } else {
    final String configJson = configFile.readAsStringSync();
    if (configJson.isNotEmpty) {
      final Object? data = json.decode(configJson);
      if (data is Map) {
        preferences = data.cast<String, String>();
      }
    }
  }

  print("Preferences: $preferences");

  runApp(app = EasyWalletApp());
  getWindowInfo().then((window) {
    final screen = window.screen;
    if (screen != null) {
      final screenFrame = screen.visibleFrame;
      final width = math.max((screenFrame.width / 2).roundToDouble(), 600.0);
      final height = math.max((screenFrame.height / 2).roundToDouble(), 400.0);
      final left = ((screenFrame.width - width) / 2).roundToDouble();
      final top = ((screenFrame.height - height) / 3).roundToDouble();
      final frame = Rect.fromLTWH(left, top, width, height);

      setWindowFrame(frame);
      setWindowMinSize(Size(0.8 * width, 0.8 * height));
      setWindowMaxSize(Size(1.5 * width, 1.5 * height));
      setWindowTitle('EasyWallet');
    }
  });
}
