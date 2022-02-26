import 'package:easy_wallet/utils.dart';
import 'package:flutter/material.dart';


class AddWalletDialog extends StatefulWidget {
  @override
  _AddWalletDialogState createState() => _AddWalletDialogState();

}

class _AddWalletDialogState extends State<AddWalletDialog> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addressController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add public wallet'),
              content: Wrap(
                children: [
                  Text("Insert the 20 bytes public address:"),
                  TextField(
                    controller: _addressController,
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
                    _addressController.clear();
                    setState(() {
                      Navigator.pop(context, "");
                    });
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: (!isWalletAddressValid(_addressController.value.text)) ? null : () {
                    Navigator.pop(context, _addressController.value.text);
                    _addressController.clear();
                  }
                )
              ],
            );
          }
        );
  }
}