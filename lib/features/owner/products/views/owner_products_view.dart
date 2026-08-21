import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/products/controllers/owner_products_controller.dart';
import 'package:smartware/features/owner/products/widgets/product_card.dart';
import 'package:smartware/features/owner/products/widgets/product_search_field.dart';
import 'package:smartware/features/owner/products/widgets/products_summary.dart';
import 'package:smartware/features/owner/products/widgets/empty_products_state.dart';

class OwnerProductsView extends StatelessWidget {
  const OwnerProductsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final OwnerProductsController controller =
        Get.find<OwnerProductsController>();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refreshProducts,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  30,
                ),
                children: [
                  // ============================================================
                  // HEADER
                  // ============================================================

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Products',
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: theme
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Material(
                        color: colors.primary,
                        borderRadius:
                            BorderRadius.circular(14),
                        child: InkWell(
                          onTap: controller.addProduct,
                          borderRadius:
                              BorderRadius.circular(14),
                          child: const SizedBox(
                            width: 46,
                            height: 46,
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ============================================================
                  // SEARCH
                  // ============================================================

                  ProductSearchField(
                    onChanged:
                        controller.searchProducts,
                  ),

                  const SizedBox(height: 14),

                  // ============================================================
                  // SUMMARY
                  // ============================================================

                  ProductsSummary(
                    controller: controller,
                  ),

                  const SizedBox(height: 22),

                  // ============================================================
                  // PRODUCTS
                  // ============================================================

                  Obx(() {
                    final products =
                        controller.filteredProducts;

                    if (products.isEmpty) {
                      return const EmptyProductsState();
                    }

                    return Column(
                      children: products.map((product) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: ProductCard(
                            product: product,
                            onTap: () {
                              controller.openProduct(
                                product,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}