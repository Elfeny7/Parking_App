import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firestore_services_new.dart';

class PlateListView extends StatefulWidget {
  const PlateListView({super.key});

  @override
  State<PlateListView> createState() => _PlateListViewState();
}

class _PlateListViewState extends State<PlateListView> {
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
        title: const Text('Plate List View'),
      ),
      body: FutureBuilder<Result?>(
        future: readResult(uid: uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final result = snapshot.data;
            return result == null
                ? const Center(
                    child: Text('No Result Yet'),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.resultList.length,
                    itemBuilder: (context, index) {
                      return buildUser(
                        snapshot.data!.resultList[index],
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
