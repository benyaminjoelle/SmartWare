import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';

class WarehouseAvailabilityButton extends StatelessWidget {
  final ProductDetailsController controller;

  const WarehouseAvailabilityButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Obx(
      () {
        final isLoading =
            controller.isCheckingAvailability.value;

        return Material(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: isLoading
                ? null
                : controller.checkWarehouseAvailability,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warehouse_outlined,
                    color: colors.surface,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoading
                              ? 'Checking availability...'.tr
                              : 'Find available warehouses'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: colors.surface,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),

                  if (isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: colors.primary,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
