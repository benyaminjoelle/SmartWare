import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/core/network/api_error.dart';

import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_repo.dart';

class OwnerHomeController extends GetxController {
  // ===========================================================================
  // REPOSITORY
  // ===========================================================================

  final OwnerAnalyticsRepo _repo = OwnerAnalyticsRepo();

  // ===========================================================================
  // STATE
  // ===========================================================================

  final userName = 'User name'.obs;
  final isLoading = false.obs;

  // ===========================================================================
  // ACTIVE WAREHOUSE
  // ===========================================================================

  final selectedWarehouse = Rxn<WarehouseModel>();

  // ===========================================================================
  // WAREHOUSES
  // ===========================================================================

  final warehouses = <WarehouseModel>[].obs;

  // ===========================================================================
  // OVERVIEW
  // ===========================================================================

  final warehouseCount = 0.obs;

  final productCount = 0.obs;

  final lowStockCount = 0.obs;

  // ===========================================================================
  // GREETING
  // ===========================================================================

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 18) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  // ===========================================================================
  // COMPUTED VALUES
  // ===========================================================================

  int get warehousesNearCapacity {
    // We do NOT have capacity information from the current backend model.
    // Keep this at zero until backend provides capacity data.
    return 0;
  }

  bool get hasAlerts {
    return lowStockCount.value > 0;
  }

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();

    loadUserName();
    loadHome();
  }

  // ===========================================================================
  // USER
  // ===========================================================================

  Future<void> loadUserName() async {
    final name = await PrefHelper.getUserName();

    if (name != null && name.isNotEmpty) {
      userName.value = name;
    }
  }

  // ===========================================================================
  // LOAD HOME
  // ===========================================================================

  Future<void> loadHome() async {
    try {
      isLoading.value = true;

      final result = await _repo.getWarehouses();

      setWarehouseData(result);
    } catch (e) {
      debugPrint('Owner Home Error: $e');

      if (e is ApiError) {
        Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar(
          'Error',
          'Failed to load warehouses',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================================
  // SET WAREHOUSE DATA
  // ===========================================================================

  void setWarehouseData(List<WarehouseModel> data) {
    warehouses.assignAll(data);

    warehouseCount.value = data.length;

    productCount.value = data.fold(
      0,
      (sum, warehouse) => sum + warehouse.productCount,
    );

    lowStockCount.value = data.fold(
      0,
      (sum, warehouse) => sum + warehouse.stockOutRiskCount,
    );

    // Keep current warehouse if it still exists.
    final currentId = selectedWarehouse.value?.id;

    if (data.isEmpty) {
      selectedWarehouse.value = null;
      return;
    }

    final matchingWarehouse = data.cast<WarehouseModel?>().firstWhere(
      (warehouse) => warehouse?.id == currentId,
      orElse: () => null,
    );

    selectedWarehouse.value = matchingWarehouse ?? data.first;
  }

  // ===========================================================================
  // REFRESH
  // ===========================================================================

  Future<void> refreshHome() async {
    await loadHome();
  }

  // ===========================================================================
  // WAREHOUSE SWITCHER
  // ===========================================================================

  void openWarehouseSwitcher(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _WarehouseSwitcherSheet(controller: this, colors: colors);
      },
    );
  }

  void selectWarehouse(WarehouseModel warehouse) {
    selectedWarehouse.value = warehouse;

    Get.back();
  }

  // ===========================================================================
  // QUICK ACTIONS
  // ===========================================================================

  void addProduct() {
    final warehouse = selectedWarehouse.value;

    if (warehouse == null) {
      Get.snackbar(
        'Warehouse required',
        'Please select a warehouse first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // TODO:
    // Navigate to Add Product.
    //
    // Use:
    // warehouse.id
    //
    // when the product API requires the facility/warehouse ID.
  }

  void addWorker() {
    final warehouse = selectedWarehouse.value;

    if (warehouse == null) {
      Get.snackbar(
        'Warehouse required',
        'Please select a warehouse first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // TODO:
    // Navigate to Add Worker.
    // Pass warehouse.id when backend requires it.
  }

  // ===========================================================================
  // NAVIGATION
  // ===========================================================================

  void openProducts() {
    // TODO: Navigate to products.
  }

  void openOrders() {
    // TODO: Navigate to orders.
  }

  void openWarehouses() {
    // TODO: Navigate to warehouses.
  }

  void openWarehouse(WarehouseModel warehouse) {
    selectedWarehouse.value = warehouse;

    // TODO:
    // Navigate to warehouse details.
    // warehouse.id is the real database ID.
  }

  void addFacility() {
    Get.toNamed(AppRoutes.ownerAddFacility);
  }
}

// =============================================================================
// WAREHOUSE SWITCHER SHEET
// =============================================================================

class _WarehouseSwitcherSheet extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _WarehouseSwitcherSheet({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Obx(() {
          final warehouses = controller.warehouses;
          final selectedId = controller.selectedWarehouse.value?.id;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurface.withOpacity(.18),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Switch warehouse',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: colors.onSurface,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.onSurface.withOpacity(.55),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (warehouses.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No warehouses available.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withOpacity(.55),
                    ),
                  ),
                )
              else
                ...warehouses.map((warehouse) {
                  final isSelected = warehouse.id == selectedId;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: _WarehouseSwitchTile(
                      warehouse: warehouse,
                      isSelected: isSelected,
                      colors: colors,
                      onTap: () {
                        controller.selectWarehouse(warehouse);
                      },
                    ),
                  );
                }),

              const SizedBox(height: 8),

              Material(
                color: colors.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(17),
                child: InkWell(
                  onTap: controller.addFacility,
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: colors.primary.withOpacity(.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(.10),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: colors.primary,
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 11),

                        Expanded(
                          child: Text(
                            'Add Facility',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: colors.primary,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: colors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// =============================================================================
// WAREHOUSE SWITCH TILE
// =============================================================================

class _WarehouseSwitchTile extends StatelessWidget {
  final WarehouseModel warehouse;
  final bool isSelected;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _WarehouseSwitchTile({
    required this.warehouse,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? colors.primary.withOpacity(.08) : Colors.transparent,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: isSelected
                  ? colors.primary.withOpacity(.18)
                  : colors.outline.withOpacity(.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.warehouse_rounded,
                  size: 21,
                  color: colors.primary,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warehouse.nameEn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: colors.onSurface.withOpacity(.45),
                        ),

                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            warehouse.location.isNotEmpty
                                ? warehouse.location
                                : 'Location unavailable',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: colors.onSurface.withOpacity(.50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (isSelected)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: colors.onPrimary,
                    size: 17,
                  ),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.onSurface.withOpacity(.22),
                  size: 21,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
