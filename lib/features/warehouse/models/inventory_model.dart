// import 'package:smartware/features/product/models/discount_model.dart';

// class ProductInventory {
//   final int id;
//   final int sectionId;
//   final int productId;
//   final int quantity;
//   final double unitPrice;
//   final List<DiscountModel> discounts;

//   ProductInventory({
//     required this.id,
//     required this.sectionId,
//     required this.productId,
//     required this.quantity,
//     required this.unitPrice,
//     required this.discounts,
//   });

//   factory ProductInventory.fromJson(Map<String, dynamic> json) {
//     return ProductInventory(
//       id: json['id'] as int,
//       sectionId: json['section_id'] as int,
//       productId: json['product_id'] as int,
//       quantity: json['quantity'] as int,
//       unitPrice: (json['unit_price'] as num).toDouble(),
//       discounts: (json['discounts'] as List<dynamic>? ?? [])
//           .map(
//             (discount) => DiscountModel.fromJson(
//               Map<String, dynamic>.from(discount),
//             ),
//           )
//           .toList(),
//     );
//   }

//   DiscountModel? get activeDiscount {
//     try {
//       return discounts.firstWhere(
//         (discount) => discount.isActive,
//       );
//     } catch (_) {
//       return null;
//     }
//   }

//   double? get discountPercentage {
//     return activeDiscount?.percentage;
//   }

//   double get discountedPrice {
//     final discount = discountPercentage;

//     if (discount == null) {
//       return unitPrice;
//     }

//     return unitPrice * (1 - discount / 100);
//   }
// }