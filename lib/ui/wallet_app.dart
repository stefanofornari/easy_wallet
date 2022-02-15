
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
          child: Column(
            children: [
              Text("No wallets yet..."),
              TextButton(
                key: KEY_ADD_WALLET,
                child: const Text('+'),
                onPressed: (){} 
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