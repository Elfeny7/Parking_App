import 'package:flutter/material.dart';

Future<void> showScanFromDialog(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text('Choose Image From'),
        children: [
          SimpleDialogOption(
            child: const Text('Camera'),
            onPressed: () {},
          ),
          SimpleDialogOption(
            child: const Text('Gallery'),
            onPressed: () {},
          ),
        ],
      );
    },
  );
}
