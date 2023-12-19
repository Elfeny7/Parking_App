import 'package:flutter/material.dart';
import 'package:ocr_license_plate/constant/route.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    toLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.yellow,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 70),
                  child: Text(
                    'Parking App',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                  ),
                ),
                CircularProgressIndicator(
                  color: Colors.black,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future toLogin() {
    return Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(homeRoute, (route) => false);
    });
  }
}
