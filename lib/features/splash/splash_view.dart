import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/splash/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/photos/SmartWare_splash.png',
        ),
      ),
    );
  }
}