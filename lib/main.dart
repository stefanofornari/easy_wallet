import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_wallet/ui/wallet_app.dart';

import 'package:window_size/window_size.dart';

void main() {
  runApp(EasyWalletApp());
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