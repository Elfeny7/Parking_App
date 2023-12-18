import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ocr_license_plate/constant/route.dart';
import 'package:ocr_license_plate/services/firestore_services_new.dart';

Future<void> showDeleteHistoryDialog(
  BuildContext context,
  String text,
  String uid,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await clearHistory(uid: uid);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
