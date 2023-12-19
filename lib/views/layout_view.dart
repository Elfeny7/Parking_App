import 'package:flutter/material.dart';
import 'package:ocr_license_plate/views/plates/plates_history_view.dart';
import 'package:ocr_license_plate/views/plates/plates_list_view.dart';
import 'package:ocr_license_plate/views/scan/scan_view.dart';
import '../constant/route.dart';
import '../enums/menu_item.dart';
import '../utilities/dialogs/logout_diaolog.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  var _currentIndex = 0;
  final List<Widget Function(BuildContext)> _pageRoutes = [
    (context) => const ScanView(),
    (context) => const PlateListView(),
    (context) => const PlateHistoryView(),
    (context) => const PlateListView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking App'),
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
      bottomNavigationBar: SalomonBottomBar(
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() {
          _currentIndex = i;
        }),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(
              Icons.camera_alt_outlined,
            ),
            title: Text("Scan"),
            selectedColor: Colors.yellow,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.list),
            title: Text("List"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.history),
            title: Text("History"),
            selectedColor: Colors.orange,
          ),

          SalomonBottomBarItem(
            icon: Icon(Icons.group),
            title: Text("About Us"),
            selectedColor: Colors.green,
          ),
        ],
      ),
      body: _pageRoutes[_currentIndex](context),
    );
  }
}
