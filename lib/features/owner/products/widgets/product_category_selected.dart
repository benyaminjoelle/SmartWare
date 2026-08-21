// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:smartware/features/owner/products/controllers/owner_add_product_controller.dart';

// class ProductCategorySelector extends StatelessWidget {
//   final AddProductController controller;

//   const ProductCategorySelector({
//     super.key,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Categories',
//           style: theme.textTheme.labelLarge?.copyWith(
//             fontWeight: FontWeight.w700,
//           ),
//         ),

//         const SizedBox(height: 8),

//         Text(
//           'Select the categories that apply to this product.',
//           style: theme.textTheme.bodySmall?.copyWith(
//             color: colors.onSurfaceVariant,
//           ),
//         ),

//         const SizedBox(height: 14),

//         Obx(() {
//           final categories = controller.availableCategories;

//           if (categories.isEmpty) {
//             return Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: colors.surfaceContainerHighest.withOpacity(.2),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: colors.outline.withOpacity(.15),
//                 ),
//               ),
//               child: Text(
//                 'No product categories are available for your account.',
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   color: colors.onSurfaceVariant,
//                 ),
//               ),
//             );
//           }

//           return Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: categories.map((category) {
//               final selected =
//                   controller.isCategorySelected(category);

//               return _CategoryChip(
//                 title: controller.categoryTitle(category),
//                 icon: controller.categoryIcon(category),
//                 selected: selected,
//                 onTap: () {
//                   controller.toggleCategory(category);
//                 },
//               );
//             }).toList(),
//           );
//         }),
//       ],
//     );
//   }
// }

// class _CategoryChip extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final bool selected;
//   final VoidCallback onTap;

//   const _CategoryChip({
//     required this.title,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(14),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           padding: const EdgeInsets.symmetric(
//             horizontal: 14,
//             vertical: 12,
//           ),
//           decoration: BoxDecoration(
//             color: selected
//                 ? colors.primary.withOpacity(.08)
//                 : colors.surfaceContainerHighest.withOpacity(.2),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: selected
//                   ? colors.primary
//                   : colors.outline.withOpacity(.15),
//               width: selected ? 1.5 : 1,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 size: 19,
//                 color: selected
//                     ? colors.primary
//                     : colors.onSurfaceVariant,
//               ),

//               const SizedBox(width: 8),

//               Text(
//                 title,
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   fontWeight:
//                       selected ? FontWeight.w700 : FontWeight.w500,
//                   color:
//                       selected ? colors.primary : colors.onSurface,
//                 ),
//               ),

//               if (selected) ...[
//                 const SizedBox(width: 7),
//                 Icon(
//                   Icons.check_circle_rounded,
//                   size: 18,
//                   color: colors.primary,
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }