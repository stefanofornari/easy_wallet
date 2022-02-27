import "package:flutter/material.dart";

import "package:crypto_font_icons/crypto_font_icons.dart";

import "package:easy_wallet/resources/constants.dart";
import "package:easy_wallet/ui/add_wallet_dialog.dart";



class EasyWalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "EasyWallet", home: EasyWalletHomePage());
  }
}

class EasyWalletHomePage extends StatefulWidget {
  late final _EasyWalletState state;


  @override
  _EasyWalletState createState() => (state = _EasyWalletState());

}

class _EasyWalletState extends State<EasyWalletHomePage> {
  List<String> _wallets = [];

  void addWallet(String wallet) {
    _wallets.add(wallet);
    setState(() {}); // TODO: move outside into the controller
  }

  void removeWallet(String wallet) {
    _wallets.remove(wallet);
    setState(() {}); // TODO: move outside into the controller
  }

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
        child: Column(
          children: _composeMainView()
        )
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        key: KEY_ADD_WALLET,
        onPressed: () async {
          addWallet(await _showAddWalletDialog(context));
          //setState(() {});
        },
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

  List<Widget> _composeMainView() {
    var children = <Widget> [
      Visibility(
        visible: _wallets.isEmpty,
        child:
          Text("No wallets yet..."),
      )
    ];

    return children + _createWalletCard();
  }

  List<Widget> _createWalletCard() {
    List<Widget> cards = [];

    _wallets.forEach((address) {
      cards.add(
        Card(
        elevation: 5,

        child: Padding(
          padding: EdgeInsets.all(7),
          child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      CryptoFontIcons.ETH,
                                      color: Colors.indigo[300],
                                      size: 40,
                                    )),
                              )
                            ],
                          )
                        ],
                      ))
                ],
              ),
            )
          ]),
          ),
        )
      );
    });

    return cards;
  }

}
