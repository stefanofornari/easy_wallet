
import 'package:flutter/material.dart';

import "package:easy_wallet/resources/constants.dart";


class EasyWalletHomePage extends StatelessWidget {
  const EasyWalletHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EasyWallet",
      home: Scaffold(
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
                onPressed: (){ print ("pressed!"); } 
              )],
          ),
        ),
        /*
        floatingActionButton: FloatingActionButton(
          onPressed: () {print("pressed!");},
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
        */
      ),
    );
  }
}