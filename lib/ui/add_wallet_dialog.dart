import 'package:easy_wallet/resources/constants.dart';
import 'package:flutter/material.dart';

import 'package:easy_wallet/ui/wallet_list_controller.dart';
import 'package:easy_wallet/ui/address_editing_controller.dart';

enum AddWalletBy { address, privateKey }


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

  AddWalletBy? _addWalletBy = AddWalletBy.address;

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
                  Row(children: [
                    Radio<AddWalletBy>(
                      key: KEY_WALLET_BY_ADDRESS,
                      value: AddWalletBy.address,
                      groupValue: _addWalletBy,
                      onChanged: (AddWalletBy? value) {
                        setState(() {
                          _addWalletBy = value;
                        });
                      }
                    ),
                    Text("address"), 
                    SizedBox(width: 25),
                    Radio<AddWalletBy>(
                      key: KEY_WALLET_BY_PRIVATE_KEY,
                      value: AddWalletBy.privateKey,
                      groupValue: _addWalletBy,
                      onChanged: (AddWalletBy? value) {
                        setState(() {
                          _addWalletBy = value;
                        });
                      }
                    ),
                    Text("private key"), 
                  ]),
                  SizedBox(height: 75),
                  Text((_addWalletBy == AddWalletBy.address) ? LABEL_ADDRESS : LABEL_PRIVATE_KEY),
                  TextField(
                    controller: addressController,
                    maxLength: 40,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                    hintText: (_addWalletBy == AddWalletBy.address) ? LABEL_ADDRESS_HINT: LABEL_PRIVATE_KEY_HINT),
                  ),
                ]
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
