import 'package:get/get.dart';

class Product {
  final int id;
  final String sku;

  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;

  final String unit;
  final List<String> categories;
  final String? imageUrl;

  final List<ProductInventory> inventories;

  Product({
    required this.id,
    required this.sku,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.unit,
    required this.categories,
    this.imageUrl,
    required this.inventories,
  });

  String get name {
    return Get.locale?.languageCode == 'ar' ? nameAr : nameEn;
  }

  String get description {
    return Get.locale?.languageCode == 'ar'
        ? descriptionAr
        : descriptionEn;
  }

  bool get hasStock {
    return inventories.any((inventory) => inventory.quantity > 0);
  }

  int get totalQuantity {
    return inventories.fold(
      0,
      (total, inventory) => total + inventory.quantity,
    );
  }

  double? get minPrice {
    if (inventories.isEmpty) return null;

    return inventories
        .map((inventory) => inventory.unitPrice)
        .reduce((a, b) => a < b ? a : b);
  }

  double? get maxPrice {
    if (inventories.isEmpty) return null;

    return inventories
        .map((inventory) => inventory.unitPrice)
        .reduce((a, b) => a > b ? a : b);
  }

  ProductInventory? get availableInventory {
    try {
      return inventories.firstWhere(
        (inventory) => inventory.quantity > 0,
      );
    } catch (_) {
      return null;
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      sku: json['sku']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString() ?? '',
      descriptionAr: json['description_ar']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (category) => _normalizeCategory(
              category['name']?.toString() ?? '',
            ),
          )
          .toList(),
      imageUrl: json['product_image']?.toString(),
      inventories: (json['inventories'] as List<dynamic>? ?? [])
          .map(
            (inventory) => ProductInventory.fromJson(
              Map<String, dynamic>.from(inventory),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name_en': nameEn,
      'name_ar': nameAr,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'unit': unit,
      'categories': categories,
      'product_image': imageUrl,
      'inventories': inventories
          .map((inventory) => inventory.toJson())
          .toList(),
    };
  }

  static String _normalizeCategory(String category) {
    return category.trim().toLowerCase().replaceAll(' ', '_');
  }
}

class ProductInventory {
  final int id;
  final int sectionId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final List<ProductDiscount> discounts;

  ProductInventory({
    required this.id,
    required this.sectionId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.discounts,
  });

  ProductDiscount? get activeDiscount {
    final activeDiscounts = discounts.where(
      (discount) => discount.isCurrentlyActive,
    );

    if (activeDiscounts.isEmpty) {
      return null;
    }

    return activeDiscounts.reduce(
      (a, b) => a.percentage > b.percentage ? a : b,
    );
  }

  bool get hasDiscount {
    return activeDiscount != null;
  }

  double get discountedPrice {
    final discount = activeDiscount;

    if (discount == null) {
      return unitPrice;
    }

    return unitPrice * (1 - discount.percentage / 100);
  }

  double get savings {
    return unitPrice - discountedPrice;
  }

  factory ProductInventory.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductInventory(
      id: json['id'] as int,
      sectionId: json['section_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      unitPrice: double.tryParse(
            json['unit_price']?.toString() ?? '',
          ) ??
          0.0,
      discounts: (json['discounts'] as List<dynamic>? ?? [])
          .map(
            (discount) => ProductDiscount.fromJson(
              Map<String, dynamic>.from(discount),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section_id': sectionId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discounts': discounts
          .map((discount) => discount.toJson())
          .toList(),
    };
  }
}

class ProductDiscount {
  final int id;
  final int inventoryId;
  final double percentage;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool isActive;

  ProductDiscount({
    required this.id,
    required this.inventoryId,
    required this.percentage,
    required this.startsAt,
    required this.endsAt,
    required this.isActive,
  });

  bool get isCurrentlyActive {
    final now = DateTime.now().toUtc();

    return isActive &&
        !now.isBefore(startsAt) &&
        !now.isAfter(endsAt);
  }

  factory ProductDiscount.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductDiscount(
      id: json['id'] as int,
      inventoryId: json['inventory_id'] as int,
      percentage: double.tryParse(
            json['percentage']?.toString() ?? '',
          ) ??
          0.0,
      startsAt: DateTime.parse(
        json['starts_at'].toString(),
      ),
      endsAt: DateTime.parse(
        json['ends_at'].toString(),
      ),
      isActive: json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inventory_id': inventoryId,
      'percentage': percentage,
      'starts_at': startsAt.toIso8601String(),
      'ends_at': endsAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}