import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileCardAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  // Reactive values to drive the UI modifications smoothly
  final glowValue = 0.0.obs;
  final scaleValue = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Sync animation ticks directly to our reactive GetX variables
    _animationController.addListener(() {
      glowValue.value = _animationController.value;
      scaleValue.value = _scaleAnimation.value;
    });
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}