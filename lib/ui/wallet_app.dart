import "package:flutter/material.dart";

import "package:easy_wallet/resources/constants.dart";
import "package:easy_wallet/ui/add_wallet_dialog.dart";

class EasyWalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "EasyWallet", home: EasyWalletHomePage());
  }
}

class EasyWalletHomePage extends StatefulWidget {
  @override
  _EasyWalletState createState() => _EasyWalletState();
}

class _EasyWalletState extends State<EasyWalletHomePage> {
  String newWalletAddress = "";

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          children: [
            Text("No wallets yet..."),
            ElevatedButton(
                key: KEY_ADD_WALLET,
                child: const Text("➕"),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                ),
                onPressed: () async {
                  newWalletAddress = await _showAddWalletDialog(context);
                  setState(() {});
                }
            )
          ],
        ),
      ),
    );
  }

  Future<String> _showAddWalletDialog(BuildContext context) async {
    
    String result = await showDialog(
      context: context,
      builder: (context) {
        return AddWalletDialog();
    });

    return result;
  }

}
