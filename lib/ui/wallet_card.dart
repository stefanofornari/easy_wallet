import 'package:flutter/material.dart';
import "package:crypto_font_icons/crypto_font_icons.dart";

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/ui/edit_private_key_dialog.dart';


class WalletCard extends StatelessWidget {

  final EasyWallet wallet;
  final Function onDelete;

  WalletCard(this.wallet, this.onDelete) : super (
    key: Key(wallet.address),    
  ) { }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                              child: _walletAddressAndCrypto()
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
                                  child: ButtonBar( 
                                    buttonPadding: EdgeInsets.all(0),
                                    children: <Widget>[
                                      InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.lock_open),
                                        ),
                                        onTap: () {
                                          _showEditPrivateKeyDialog(context);
                                        },
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.delete),
                                        ),
                                        onTap: () {
                                          onDelete();
                                        },
                                      ),
                                    ]
                                  )
                                )
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
      )
    );
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

  Widget _walletAddressAndCrypto() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: "0x" + wallet.address,
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
                  fontWeight: FontWeight.bold
                )
            ),
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
                text: "\n ${wallet.readableBalance}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _showEditPrivateKeyDialog(BuildContext context) async {
    
    String result = await showDialog(
      context: context,
      builder: (context) {
        return EditPrivateKeyDialog(wallet);
    });

    return result;
  }

}