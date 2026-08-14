import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/ads_carousel_controller.dart';

class AutoMovingAdsCarousel extends GetView<AdsCarouselController> {
  final List<String>? images;
  final double height;
  final String? controllerTag;

  const AutoMovingAdsCarousel({
    super.key,
    this.images,
    this.height = 180,
    this.controllerTag,
  });
  @override
  AdsCarouselController get controller => Get.find<AdsCarouselController>(tag: controllerTag);

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(AdsCarouselController(), tag: controllerTag);
    final colors = Theme.of(context).colorScheme;

    return Obx(() {
       final activeImages = (images != null && images!.isNotEmpty)
        ? images!
        : controller.imageUrls;

      if (activeImages.isEmpty) {
        return SizedBox(height: height);
      }

      return Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          SizedBox(
            height: height,
            child: Card(
              elevation: 2,
              color: colors.surface,
              margin: EdgeInsets.zero,
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.infinitePoolCount,
                onPageChanged: controller.handlePageChange,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final realIndex = index % activeImages.length;
                  final imgUrl = activeImages[realIndex];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: colors.surfaceContainerHighest.withOpacity(0.3),
                            child: const Center(child: CircularProgressIndicator.adaptive()),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: colors.surfaceContainerHighest.withOpacity(0.3),
                          child: const Icon(Icons.broken_image_outlined, size: 40),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (activeImages.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(activeImages.length, (index) {
                final bool isActive = index == controller.currentRealIndex.value;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: isActive ? 18 : 6,
                  decoration: BoxDecoration(
                    color: isActive ? colors.primary : colors.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
        ],
      );
    });
  }
}