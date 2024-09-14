import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBarInDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Message"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CLOSE"),
          ),
        ],
      );
    },
  );
}


void showSnackBarInDialogClose(BuildContext context, String message, VoidCallback onClose) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Message"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onClose != null) {
                onClose();
              }
            },
            child: Text("CLOSE"),
          ),
        ],
      );
    },
  );
}

