import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/cart/views/client_cart_view.dart';
import 'package:smartware/features/client/home/client_home_view.dart';
import 'package:smartware/features/client/orders/views/client_orders_view.dart';
import 'package:smartware/features/client/profile/views/client_profile_view.dart';
import 'package:smartware/features/client/root/controller/root_controller.dart';

class ClientRootView extends GetView<RootController> {
  const ClientRootView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context).colorScheme;

    final pages = [
      const ClientHomeView(),

      ClientCartView(),
      ClientOrdersView(),
      const ClientProfileView(),
    ];

    return Scaffold(
      extendBody: true,

      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: pages[controller.currentIndex.value],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: media.size.width * 0.04,
          right: media.size.width * 0.04,
          bottom: media.size.height * 0.02,
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),

            child: Container(
              height: media.size.height * 0.085,
              decoration: BoxDecoration(
                color: theme.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.outline.withValues(alpha: 0.08),
                ),
              ),

              child: Theme(
                data: Theme.of(context).copyWith(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                ),

                child: Obx(
                  () => NavigationBarTheme(
                    data: NavigationBarThemeData(
                      backgroundColor: Colors.transparent,
                      elevation: 0,

                      indicatorColor: Colors.transparent,

                      overlayColor: WidgetStateProperty.all(Colors.transparent),

                      labelTextStyle: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          );
                        }

                        return TextStyle(
                          color: theme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        );
                      }),

                      iconTheme: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return IconThemeData(color: theme.primary, size: 26);
                        }

                        return IconThemeData(
                          color: theme.onSurface.withValues(alpha: 0.6),
                          size: 24,
                        );
                      }),
                    ),

                    child: NavigationBar(
                      selectedIndex: controller.currentIndex.value,

                      onDestinationSelected: controller.changePage,

                      height: media.size.height * 0.085,

                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysShow,

                      destinations: [
                        _destination(
                          icon: Icons.home_outlined,
                          selectedIcon: Icons.home_rounded,
                          label: "Home".tr,
                        ),

                        _destination(
                          icon: Icons.shopping_cart_outlined,
                          selectedIcon: Icons.shopping_cart_outlined,
                          label: "Cart".tr,
                        ),

                        _destination(
                          icon: Icons.local_shipping,
                          selectedIcon: Icons.local_shipping,
                          label: "Orders".tr,
                        ),

                        _destination(
                          icon: Icons.person_outline_rounded,
                          selectedIcon: Icons.person_rounded,
                          label: "Profile".tr,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  NavigationDestination _destination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon),
      label: label,
    );
  }
}
