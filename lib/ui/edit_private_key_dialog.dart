import 'package:easy_wallet/resources/constants.dart';
import 'package:flutter/material.dart';

import 'package:easy_wallet/easy_wallet.dart';
import 'package:easy_wallet/ui/address_editing_controller.dart';
import 'package:easy_wallet/ui/mnemonic_phrase_editing_controller.dart';

class EditPrivateKeyDialog extends StatefulWidget {
  final EasyWallet wallet;

  EditPrivateKeyDialog(this.wallet);

  @override
  _EditPrivateKeyDialogState createState() => _EditPrivateKeyDialogState(wallet);
}

class _EditPrivateKeyDialogState extends State<EditPrivateKeyDialog> {
  final EasyWallet wallet;
  final WalletEditingController keyController = WalletEditingController();
  final MnemonicEditingController passphraseController = MnemonicEditingController();

  _EditPrivateKeyDialogState(this.wallet);

  @override
  void initState() {
    super.initState();
    keyController.clear();
    passphraseController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    keyController.dispose();
    passphraseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text("Edit 0x${wallet.address}'s private key"),
          content: Wrap(
                children: [
                  Text(LABEL_MNEMONIC_PHRASE),
                  TextField(
                    key: KEY_MNEMONIC_PHRASE,
                    controller: passphraseController,
                    onChanged: (value) {
                      _setPrivateKeyIfValidPassphrase(value);
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: (LABEL_MNEMONIC_PHRASE_HINT),
                    )
                  ),
                  SizedBox(height: 75),
                  Align(
                    alignment: Alignment.center,
                    child: const Text("-- or ---"),
                  ),
                  SizedBox(height: 40),
                  Text(_isPrivateKeyEnabled() ? LABEL_PRIVATE_KEY : LABEL_PRIVATE_KEY_MNEMONIC),
                  TextField(
                    key: KEY_PRIVATE_KEY,
                    maxLength: 64,
                    controller: keyController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    enabled: _isPrivateKeyEnabled(),
                    decoration: InputDecoration(
                      hintText: (_isPrivateKeyEnabled() ? LABEL_PRIVATE_KEY_HINT: "")
                    ),
                  )
                ]
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    keyController.clear();
                    setState(() {
                      Navigator.pop(context, "");
                    });
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: !_validate() ? null : () {
                    Navigator.pop(context, "");
                  }
                )
              ]
        );
      }
    );
  }

  bool _validate() {
    //
    // If the key is invalid key2adress returns an empty address...
    //
    print("${wallet.address} == " + keyController.key2address());
    return wallet.address == keyController.key2address();
      
  }

  bool _isPrivateKeyEnabled() {
    return passphraseController.value.text.isEmpty;
  }

  void _setPrivateKeyIfValidPassphrase(value) {
    keyController.text = passphraseController.privateKey(wallet.address);
  }
}