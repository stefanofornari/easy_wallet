
import 'package:flutter/material.dart';

import "package:easy_wallet/resources/constants.dart";

class EasyWalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EasyWallet",
      home: EasyWalletHomePage()
    );
  }
}


class EasyWalletHomePage extends StatelessWidget {
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
                onPressed: (){ _showAddWalletDialog(context); } 
              )],
          ),
        ),
    );
  }

  Future<void> _showAddWalletDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add public wallet'),
            content: Wrap(
              children: [
                Text("Insert the 20 bytes public address:"),
                TextField(
                  onChanged: (value) {
                },
                decoration: InputDecoration(hintText: "eg: 00000000219ab540356cBB839Cbe05303d7705Fa"),
               ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                    Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}