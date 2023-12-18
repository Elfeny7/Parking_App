import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.storage,
                  Permission.camera,
                ].request();
                if (statuses[Permission.storage]!.isGranted &&
                    statuses[Permission.camera]!.isGranted) {
                  Navigator.of(context)
                      .pushNamed(scanViewRoute, arguments: {'in': true});
                } else {
                  print('no permission provided');
                }
              },
              child: const Text('Scan License Number'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(plateListRoute);
              },
              child: const Text('List Parked License'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(plateHistoryRoute);
              },
              child: const Text('History Parked License'),
            ),
          ],
        ),
      ),
    );
  }
}
