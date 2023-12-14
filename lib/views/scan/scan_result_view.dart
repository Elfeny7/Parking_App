import 'package:flutter/material.dart';
import 'package:ocr_license_plate/constant/route.dart';
import 'package:ocr_license_plate/services/firestore_services.dart';

class ScanResultView extends StatefulWidget {
  const ScanResultView({super.key});

  @override
  State<ScanResultView> createState() => _ScanResultViewState();
}

class _ScanResultViewState extends State<ScanResultView> {
  String textResult = 'AG 7988 EBS';

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
            Text(textResult),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(plateRoute, (route) => false);
                  },
                  child: const Text('Keluar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirestoreServices.createOrUpdateResult("1", textResult: textResult);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
