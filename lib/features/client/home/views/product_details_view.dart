import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';
import 'package:smartware/features/client/home/widgets/bottom_cart_bar.dart';
import 'package:smartware/features/client/home/widgets/floating_button.dart';
import 'package:smartware/features/client/home/widgets/info_row.dart';
import 'package:smartware/features/client/home/widgets/nowarehouse_state.dart';
import 'package:smartware/features/client/home/widgets/product_details_section_title.dart';
import 'package:smartware/features/client/home/widgets/product_hero_image.dart';
import 'package:smartware/features/client/home/widgets/quantity_selector.dart';
import 'package:smartware/features/client/home/widgets/warehouse_availabilty_button.dart';
import 'package:smartware/features/client/home/widgets/warehouse_selection.dart';
import 'package:smartware/widgets/back_button.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final controller = Get.find<ProductDetailsController>();
    final product = controller.product;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                ProductHeroImage(
                  imageUrl: product.imageUrl,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    22,
                    20,
                    140,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // COMPANY
                      // Text(
                      //   product.companyName,
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: theme.textTheme.labelMedium?.copyWith(
                      //     color: colors.primary,
                      //     fontWeight: FontWeight.w800,
                      //     letterSpacing: 0.8,
                      //   ),
                      // ),

                      // const SizedBox(height: 8),

                      // PRODUCT NAME
                      Text(
                        product.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // SKU
                      Text(
                        'SKU: ${product.sku}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // CATEGORIES
                      if (product.categories.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.categories
                              .map(
                                (category) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    category,
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: colors.surface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                      const SizedBox(height: 24),

                    // DESCRIPTION
                    if (product.description.isNotEmpty) ...[
                      Text(
                        'Description',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        product.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],

                      // CONTAINER TYPE
                      InfoRow(
                        icon: Icons.inventory_2_outlined,
                        title: 'Container',
                        value: product.unit,
                      ),

                      const SizedBox(height: 24),

                      const SectionTitle(
                        title: 'Quantity',
                        subtitle: 'Choose how much you need',
                      ),
                
                      const SizedBox(height: 12),
                      QuantitySelector(
                        controller: controller,),
                      const SizedBox(height: 28),
                      WarehouseAvailabilityButton(
                        controller: controller,
                      ),

                      const SizedBox(height: 20),

                      Obx(
                        () {
                          if (!controller.hasCheckedAvailability.value) {
                            return const SizedBox.shrink();
                          }

                          if (controller.availableWarehouses.isEmpty) {
                            return const NoWarehouseState();
                          }

                          return WarehouseSelection(
                            controller: controller,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 14,
              left: 16,
              child: CustomBackButton(),               
              ),
            
            Positioned(
              top: 14,
              right: 16,
              child: FloatingButton(
                icon: Icons.shopping_bag_outlined,
                onTap: () {
                  Get.toNamed('/clientCart');
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomCartBar(
                controller: controller,
                product: product,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

