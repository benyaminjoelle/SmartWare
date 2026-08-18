// import 'package:flutter/material.dart';
// import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';

// class ClientWarehouseProductCard extends StatelessWidget {
//   final WarehouseProduct warehouseProduct;

//   const ClientWarehouseProductCard({
//     super.key,
//     required this.warehouseProduct,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     final item = warehouseProduct;

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.warehouse_outlined,
//                   color: colors.primary,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     item.warehouseName,
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             Row(
//               children: [
//                 Icon(
//                   Icons.location_on_outlined,
//                   size: 18,
//                   color: colors.outline,
//                 ),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: Text(
//                     item.address,
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Text(
//                   '\$${item.discountedPrice.toStringAsFixed(2)}',
//                   style: theme.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: colors.primary,
//                   ),
//                 ),

//                 if (item.hasDiscount) ...[
//                   const SizedBox(width: 8),
//                   Text(
//                     '\$${item.price.toStringAsFixed(2)}',
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       decoration: TextDecoration.lineThrough,
//                       color: colors.outline,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     '${item.discountPercentage!.toStringAsFixed(0)}% OFF',
//                     style: TextStyle(
//                       color: colors.error,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }