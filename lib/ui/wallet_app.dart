
import 'package:flutter/material.dart';


class EasyWalletHomePage extends StatelessWidget {
  const EasyWalletHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EasyWallet",
      home: Scaffold(
//        appBar: AppBar(
//          title: const Text("EasyWallet"),
//        ),
        body: const Center(
          child: Text("No wallets yet..."),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Add',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}