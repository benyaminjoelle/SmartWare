
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';
import 'package:smartware/features/client/home/widgets/quantity_button.dart';

class QuantitySelector extends StatelessWidget {
  final ProductDetailsController controller;

  const QuantitySelector({
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
            child: Center(
              child: Obx(
                () => Text(
                  '${controller.quantity.value}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
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
