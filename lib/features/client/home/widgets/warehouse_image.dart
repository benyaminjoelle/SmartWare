// import 'package:flutter/material.dart';

// class WarehouseImage extends StatelessWidget {
//   final String? imageUrl;

//   const WarehouseImage({
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     final hasImage =
//         imageUrl != null && imageUrl!.trim().isNotEmpty;

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(13),
//       child: SizedBox(
//         width: 52,
//         height: 52,
//         child: hasImage
//             ? Image.network(
//                 imageUrl!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) {
//                   return _empty(colors);
//                 },
//               )
//             : _empty(colors),
//       ),
//     );
//   }

//   Widget _empty(ColorScheme colors) {
//     return Container(
//       color: colors.surfaceContainerHighest.withOpacity(0.45),
//       child: Icon(
//         Icons.warehouse_outlined,
//         size: 24,
//         color: colors.onSurfaceVariant.withOpacity(0.5),
//       ),
//     );
//   }
// }
