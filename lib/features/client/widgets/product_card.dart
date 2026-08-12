import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/product/models/product_model.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, 
  required this.product
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final controller = Get.find<CartController>();

    return GestureDetector(
      onTap: () {
        Get.toNamed('/product-details', arguments: product);
      },
    child:  Container(
      width: 160, // Fixed width guarantees the partial item layout look on screen edges
      margin: const EdgeInsets.only(right: 14, bottom: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Product Image Thumbnail area
        Expanded(
          child: Stack(
            children :[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 130,
                  width: double.infinity,
                  color: colors.surfaceContainerLow,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>  Center(
                      child: Icon(Icons.inventory_2_outlined, size: 40, color: colors.onPrimary),
                    ),
                  ),
                ),
              ),
                      if (product.hasDiscount)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)], // Vivid coral/red
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF416C).withOpacity(0.4), // Glowing shadow match
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  "${product.discountPercentage?.toStringAsFixed(0)}% OFF",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
            ] 
          ),
        ),
          // 2. Info Description Area
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                  
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                     product.productType,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Price Tag display info
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ], 
                ),
                 const Spacer(),
                 InkWell(
                          onTap: () {
                            controller.addToCart(product);
                            AppSnackbar.show(
                            title: "Added to Cart",
                            message: "${product.name} has been added to your cart.",
                            position: SnackPosition.TOP,
                
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                       ]
                     ),
                    )
                  ],
                 ),
              ),
          );
        }
      }