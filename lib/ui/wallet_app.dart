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

    for (var address in _wallets) {
      cards.add(
        Card(
          key: Key(address),
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
                                _cryptoIcon(),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: _walletAddressAndCrypto(address)
                                ),
                              ],
                            ),
                            IntrinsicHeight(
                              child: Row(
                                children: <Widget>[
                                  _cryptoAmount(),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton(
                                        child: const Icon(Icons.delete),
                                        style: ElevatedButton.styleFrom(
                                          shape: CircleBorder(),
                                          primary: Colors.blueGrey
                                        ),
                                        onPressed: () {
                                          removeWallet(address);
                                        }
                                      ),
                                    ),
                                  )
                                ]
                              )
                            )
                          ],
                        )
                      )
                  ],
                ),
              )
            ]),
          ),
        )
      );
    };

    return cards;
  }

  Widget _cryptoIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            CryptoFontIcons.ETH,
            size: 40,
          )
      ),
    );
  }

  Widget _walletAddressAndCrypto(String address) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: "0x" + address,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.black, 
            fontSize: 20,
            overflow: TextOverflow.ellipsis
          ),

          children: <TextSpan>[
            TextSpan(
                text: "\nEthereum - ETH",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      )
     );
  }


  Widget _cryptoAmount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "\n\$12.279",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "\n0.1349",
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
