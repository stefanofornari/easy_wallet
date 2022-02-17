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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

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
                onPressed: () {
                  _showAddWalletDialog(context);
                })
          ],
        ),
      ),
    );
  }

  Future<void> _showAddWalletDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AddWalletDialog();
          });
        });
  }
}
