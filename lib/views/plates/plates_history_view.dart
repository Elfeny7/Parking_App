import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ocr_license_plate/utilities/dialogs/delete_history_dialog.dart';

import '../../services/firestore_services_new.dart';

class PlateHistoryView extends StatefulWidget {
  const PlateHistoryView({super.key});

  @override
  State<PlateHistoryView> createState() => _PlateHistoryViewState();
}

class _PlateHistoryViewState extends State<PlateHistoryView> {
  late String uid;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plate History'),
        actions: [
          IconButton(
            onPressed: () async {
              await showDeleteHistoryDialog(
                  context, "Are you sure want to delete all history?", uid);
              final snackBar = SnackBar(
                content: const Text('History deleted successfuly'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
            },
            tooltip: 'Delete all history',
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: FutureBuilder<History?>(
        future: readHistory(uid: uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final result = snapshot.data!.historyList;
            return result.isEmpty
                ? const Center(
                    child: Text('No Result Yet'),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.historyList.length,
                    itemBuilder: (context, index) {
                      return buildUser(
                        snapshot.data!.historyList[index],
                      );
                    },
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildUser(String resultItem) => ListTile(
        title: Text(resultItem),
      );
}
