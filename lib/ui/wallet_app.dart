import 'package:easy_wallet/utils.dart';
import "package:flutter/material.dart";

import "package:easy_wallet/resources/constants.dart";

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
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addressController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
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
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Add public wallet'),
                content: Wrap(
                  children: [
                    Text("Insert the 20 bytes public address:"),
                    TextField(
                      controller: _addressController,
                      maxLength: 40,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          hintText: "eg: 00000000219ab540356cBB839Cbe05303d7705Fa"),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      _addressController.clear();
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                  TextButton(
                    child: const Text('OK'),
                    onPressed: (!isWalletAddressValid(_addressController.value.text)) ? null : () {
                      Navigator.pop(context);
                      _addressController.clear();
                    }
                  )
                ],
              );
            }
          );
        });
  }

}
