import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdsCarouselController extends GetxController {
  // 1. Observable list: When you load data from your backend API later, 
  // simply assign the results here and the UI will update dynamically.
  final RxList<String> imageUrls = <String>[
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=800&q=80',
  ].obs;

  // Track the actual real index (0, 1, 2) for your indicators
  final RxInt currentRealIndex = 0.obs;
  
  late final PageController pageController;
  final int infinitePoolCount = 100000;
  Timer? _autoScrollTimer;
  int _virtualPage = 0;

  @override
  void onInit() {
    super.onInit();
    
    // Calculate a perfect mid-point that aligns exactly with index 0
    final int startingMidPoint = infinitePoolCount ~/ 2;
    final int remainder = startingMidPoint % (imageUrls.isNotEmpty ? imageUrls.length : 1);
    _virtualPage = startingMidPoint - remainder;

    pageController = PageController(initialPage: _virtualPage);
    startAutoScroll();
  }

  void startAutoScroll() {
    _autoScrollTimer?.cancel(); // Clear any existing timers safely
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients) {
        _virtualPage++;
        pageController.animateToPage(
          _virtualPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void handlePageChange(int index) {
    _virtualPage = index;
    if (imageUrls.isNotEmpty) {
      // Keeps the active indicator synchronized regardless of swipe direction
      currentRealIndex.value = index % imageUrls.length;
    }
  }

  @override
  void onClose() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}