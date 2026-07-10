import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/client/home/controllers/ads_carousel_controller.dart';

class AutoMovingAdsCarousel extends StatelessWidget {
  const AutoMovingAdsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject or find your controller pipeline dependencies 
    final controller = Get.put(AdsCarouselController());
    final colors = Theme.of(context).colorScheme;

    return Obx(() {
      // Fallback state context handling if the data list is empty
      if (controller.imageUrls.isEmpty) {
        return const SizedBox(height: 110);
      }

      return Column(
        children: [
          // Infinite horizontal scrolling card box view
          SizedBox(
            height: 110,
            child: Card(
              elevation: 2,
              color: colors.surface,
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.infinitePoolCount,
                onPageChanged: controller.handlePageChange,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final realIndex = index % controller.imageUrls.length;
                  final imgUrl = controller.imageUrls[realIndex];
                        
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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

          // Dynamic Moving Indicator Dots Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.imageUrls.length, (index) {
              final bool isActive = index == controller.currentRealIndex.value;
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                // Expanding layout pill shape for your modern, minimal aesthetic
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