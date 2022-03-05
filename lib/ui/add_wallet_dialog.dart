import 'package:flutter/material.dart';

import 'package:easy_wallet/ui/wallet_list_controller.dart';
import 'package:easy_wallet/ui/address_editing_controller.dart';


class AddWalletDialog extends StatefulWidget {
  final WalletListController listController;

  AddWalletDialog(this.listController) {}

  @override
  _AddWalletDialogState createState() => _AddWalletDialogState(listController);
}

class _AddWalletDialogState extends State<AddWalletDialog> {
  final WalletListController listController;

  _AddWalletDialogState(this.listController) {}

  final AddressEditingController addressController = AddressEditingController();

  @override
  void initState() {
    super.initState();
    addressController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add public wallet'),
              content: Wrap(
                children: [
                  Text("Insert the 20 hex bytes public address:"),
                  TextField(
                    controller: addressController,
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
                    addressController.clear();
                    setState(() {
                      Navigator.pop(context, "");
                    });
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: !_validate(addressController.value.text) ? null : () {
                    Navigator.pop(context, addressController.value.text);
                    addressController.clear();
                  }
                )
              ],
            );
          }
        );
  }

  bool _validate(String address) {
    return 
      addressController.isValidAddress(addressController.value.text) 
      &&
      listController.isValidAddress(addressController.value.text);
  }
}
