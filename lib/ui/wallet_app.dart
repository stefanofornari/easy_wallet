import "package:flutter/material.dart";

import "package:easy_wallet/resources/constants.dart";
import "package:easy_wallet/ui/add_wallet_dialog.dart";

import "package:easy_wallet/easy_wallet.dart";
import "package:easy_wallet/ui/wallet_card.dart";
import "package:easy_wallet/ui/wallet_list_controller.dart";


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
  final WalletListController controller = WalletListController();

  void _onChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.value.clear();
    controller.addListener(_onChange);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            key: KEY_REFRESH,
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.retrieveBalance();
            }
          ),
          /*
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Refresh'),
                ),
              ),
            ],
          ),
          */
        ],
      ),
      body: Center(
        child: Column(
          children: _composeMainView()
        )
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        key: KEY_ADD_WALLET,
        onPressed: () async {
          String address = await _showAddWalletDialog(context);
          if (address.isNotEmpty) {
            controller + EasyWallet(address);
          }
        },
      ),
    );
  }

  Future<String> _showAddWalletDialog(BuildContext context) async {
    
    String result = await showDialog(
      context: context,
      builder: (context) {
        return AddWalletDialog(controller);
    });

    return result;
  }

  List<Widget> _composeMainView() {
    var children = <Widget> [
      Visibility(
        visible: controller.value.isEmpty,
        child:
          Text("No wallets yet..."),
      )
    ];

    return children + _createWalletCard();
  }

  List<Widget> _createWalletCard() {
    List<Widget> cards = [];

    for (var wallet in controller.value) {
      cards.add(
        WalletCard(wallet, () {controller - wallet.address;})
      );
    }

    return cards;
  }


}
