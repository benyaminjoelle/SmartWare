import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingCarouselController extends GetxController {
  late final PageController pageController;

  final RxInt currentPage = 0.obs;

  Timer? _timer;

  final List<FeatureItem> features = [
    FeatureItem(
      icon: Icons.warehouse_outlined,
      title: "Smart Inventory".tr,
      description: "Track stock in real-time with zero effort.".tr,
    ),
    FeatureItem(
      icon: Icons.insights_outlined,
      title: "Live Analytics".tr,
      description: "Understand your warehouse like a living system.".tr,
    ),
    FeatureItem(
      icon: Icons.local_shipping_outlined,
      title: "Fast Logistics".tr,
      description: "Optimize shipping routes automatically.".tr,
    ),
    FeatureItem(
      icon: Icons.security_outlined,
      title: "Secure System".tr,
      description: "Your data protected with layered security.".tr,
    ),
  ];

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(viewportFraction: 0.80);

    _startAutoScroll();
  }

  // 🧠 separated logic = cleaner + easier to optimize
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!Get.isRegistered<OnboardingCarouselController>()) {
        timer.cancel();
        return;
      }

      if (!pageController.hasClients) return;

      final nextPage =
          (currentPage.value + 1) % features.length;

      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _timer = null;

    pageController.dispose();

    super.onClose();
  }
}

class FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
