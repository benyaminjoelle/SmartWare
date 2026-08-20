import 'package:flutter/material.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';
import 'package:smartware/features/client/home/widgets/quantity_button.dart';

class QuantitySelector extends StatelessWidget {
  final ProductDetailsController controller;

  const QuantitySelector({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          QuantityButton(
            icon: Icons.remove_rounded,
            onTap: controller.decreaseQuantity,
          ),

          Expanded(
            child: TextField(
              controller: controller.quantityController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
              onChanged: controller.onQuantityChanged,
              onSubmitted: (_) {
                controller.onQuantitySubmitted();
              },
            ),
          ),

          QuantityButton(
            icon: Icons.add_rounded,
            onTap: controller.increaseQuantity,
          ),
        ],
      ),
    );
  }
}