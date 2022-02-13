import 'package:flutter_test/flutter_test.dart';

import 'package:easy_wallet/ui/wallet_app.dart';
//import 'package:easy_wallet/wallet.dart';

void main() {
  group('empty home page', () {
    testWidgets('show_main_window', (WidgetTester tester) async {
      await tester.pumpWidget(EasyWalletHomePage());


      expect(find.text("No wallets yet..."), findsWidgets);
    });
  });
}
