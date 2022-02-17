import 'package:flutter/material.dart';

class AddWalletDialog extends AlertDialog {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add public wallet'),
      content: Wrap(
        children: [
          Text("Insert the 20 bytes public address:"),
          TextField(
            onChanged: (value) {},
            decoration: InputDecoration(
                hintText: "eg: 00000000219ab540356cBB839Cbe05303d7705Fa"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
