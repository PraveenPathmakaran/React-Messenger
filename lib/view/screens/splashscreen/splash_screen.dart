import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../const/const.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (await Permission.storage.status.isGranted) {
          await Future<void>.delayed(const Duration(seconds: 2));
          Get.offAll(() => const MobileScreenLayout());
        } else {
          Get.snackbar('Error', 'Permission denied');
        }
      },
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(logoPath),
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  'assets/loading.json',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
