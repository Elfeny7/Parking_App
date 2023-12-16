import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ocr_license_plate/constant/route.dart';
import 'package:ocr_license_plate/services/firestore_services.dart';
import 'package:ocr_license_plate/services/firestore_services_new.dart';

import '../../utilities/dialogs/error_dialog.dart';

class ScanResultView extends StatefulWidget {
  const ScanResultView({super.key});

  @override
  State<ScanResultView> createState() => _ScanResultViewState();
}

class _ScanResultViewState extends State<ScanResultView> {
  String scanResult = 'AG 7983 EB';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan Result View',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Hasil Scan:'),
            Text(scanResult),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(plateRoute, (route) => false);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final uid = user.uid;
                      await createResult(uid: uid, textResult: scanResult);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          plateRoute, (route) => false);
                    } else {
                      await showErrorDialog(
                        context,
                        'User not found',
                      );
                    }
                  },
                  child: const Text('Enter Parking'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final uid = user.uid;
                      await deleteResult(uid: uid, textResult: scanResult);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          plateRoute, (route) => false);
                    } else {
                      await showErrorDialog(
                        context,
                        'User not found',
                      );
                    }
                  },
                  child: const Text('Exit Parking'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
