import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ocr_license_plate/utilities/dialogs/scan_from_dialog.dart';
import '../../constant/route.dart';
import '../../enums/menu_item.dart';
import '../../utilities/dialogs/logout_diaolog.dart';

class PlateView extends StatefulWidget {
  const PlateView({super.key});

  @override
  State<PlateView> createState() => _PlateViewState();
}

class _PlateViewState extends State<PlateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plates View'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  await showLogOutDialog(
                    context,
                    "Are you sure want to log out?",
                  );
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showScanFromDialog(context);
                  },
                  child: const Text('Scan Masuk'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Keluar Parkir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
