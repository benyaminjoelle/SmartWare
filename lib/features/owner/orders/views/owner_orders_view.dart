// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:smartware/features/owner/orders/controllers/owner_orders_controller.dart';

// class OwnerOrdersView extends StatelessWidget {
//   const OwnerOrdersView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final OwnerOrdersController controller =
//         Get.find<OwnerOrdersController>();

//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

    // return Scaffold(
      
    //   body: SafeArea(
    //     child: GestureDetector(
    //       onTap: () {
    //         FocusScope.of(context).unfocus();
    //       },
    //       child: Obx(() {
    //         if (controller.isLoading.value) {
    //           return const Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }

//             return RefreshIndicator(
//               onRefresh: controller.refreshOrders,
//               child: ListView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.fromLTRB(
//                   20,
//                   18,
//                   20,
//                   30,
//                 ),
//                 children: [
//                   // ==========================================================
//                   // HEADER
//                   // ==========================================================

//                   Text(
//                     'Orders',
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),

//                   const SizedBox(height: 5),

//                   Text(
//                     'Manage your warehouse orders',
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: colors.onSurfaceVariant,
//                     ),
//                   ),

//                   const SizedBox(height: 22),

//                   // ==========================================================
//                   // TABS
//                   // ==========================================================

//                   _OrdersTabs(
//                     controller: controller,
//                   ),

//                   const SizedBox(height: 22),

//                   // ==========================================================
//                   // CONTENT
//                   // ==========================================================

//                   Obx(() {
//                     switch (controller.selectedTab.value) {
//                       case OrderTab.pending:
//                         return _PendingOrdersTab(
//                           controller: controller,
//                         );

//                       case OrderTab.incoming:
//                         return _IncomingOrdersTab(
//                           controller: controller,
//                         );

//                       case OrderTab.outgoing:
//                         return _OutgoingOrdersTab(
//                           controller: controller,
//                         );
//                     }
//                   }),
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

// // =============================================================================
// // TABS
// // =============================================================================

// class _OrdersTabs extends StatelessWidget {
//   final OwnerOrdersController controller;

//   const _OrdersTabs({
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: colors.surfaceContainerHighest.withOpacity(0.55),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           _OrderTabButton(
//             label: 'Pending',
//             count: controller.pendingCount,
//             tab: OrderTab.pending,
//             controller: controller,
//           ),
//           _OrderTabButton(
//             label: 'Incoming',
//             count: controller.incomingCount,
//             tab: OrderTab.incoming,
//             controller: controller,
//           ),
//           _OrderTabButton(
//             label: 'Outgoing',
//             count: controller.outgoingCount,
//             tab: OrderTab.outgoing,
//             controller: controller,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OrderTabButton extends StatelessWidget {
//   final String label;
//   final int count;
//   final OrderTab tab;
//   final OwnerOrdersController controller;

//   const _OrderTabButton({
//     required this.label,
//     required this.count,
//     required this.tab,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     final isSelected =
//         controller.selectedTab.value == tab;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           controller.changeTab(tab);
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           padding: const EdgeInsets.symmetric(
//             vertical: 10,
//             horizontal: 5,
//           ),
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? colors.surface
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(11),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.035),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Flexible(
//                 child: Text(
//                   label,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: isSelected
//                         ? colors.onSurface
//                         : colors.onSurfaceVariant,
//                     fontSize: 12,
//                     fontWeight: isSelected
//                         ? FontWeight.w700
//                         : FontWeight.w500,
//                   ),
//                 ),
//               ),

//               if (count > 0) ...[
//                 const SizedBox(width: 5),

//                 Container(
//                   constraints: const BoxConstraints(
//                     minWidth: 18,
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 5,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? colors.primaryContainer
//                         : colors.surface,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     count.toString(),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w800,
//                       color: colors.primary,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =============================================================================
// // PENDING
// // =============================================================================

// class _PendingOrdersTab extends StatelessWidget {
//   final OwnerOrdersController controller;

//   const _PendingOrdersTab({
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (controller.pendingOrders.isEmpty) {
//       return const _OrdersEmptyState(
//         icon: Icons.mark_email_read_outlined,
//         title: 'No pending orders',
//         subtitle: 'New client requests will appear here.',
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionIntro(
//           title: 'Client requests',
//           subtitle:
//               'Review these orders before accepting them.',
//         ),

//         const SizedBox(height: 12),

//         ...controller.pendingOrders.map(
//           (order) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: _PendingOrderCard(
//                 order: order,
//                 onTap: () {
//                   _showPendingOrderDetails(
//                     context,
//                     controller,
//                     order,
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// // =============================================================================
// // PENDING ORDER CARD
// // =============================================================================

// class _PendingOrderCard extends StatelessWidget {
//   final ClientOrderModel order;
//   final VoidCallback onTap;

//   const _PendingOrderCard({
//     required this.order,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Material(
//       color: colors.surface,
//       borderRadius: BorderRadius.circular(19),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(19),
//         // child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   _OrderAvatar(
//                     imageUrl: order.clientImageUrl,
//                     icon: Icons.person_outline_rounded,
//                   ),

//                   const SizedBox(width: 12),

//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           order.clientName,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),

//                         const SizedBox(height: 4),

//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on_outlined,
//                               size: 14,
//                               color: colors.onSurfaceVariant,
//                             ),

//                             const SizedBox(width: 3),

//                             Expanded(
//                               child: Text(
//                                 order.clientLocation,
//                                 maxLines: 1,
//                                 overflow:
//                                     TextOverflow.ellipsis,
//                                 style: theme.textTheme.bodySmall
//                                     ?.copyWith(
//                                   color:
//                                       colors.onSurfaceVariant,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(width: 8),

//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 14,
//                     color: colors.onSurfaceVariant,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 14),

//               Divider(
//                 height: 1,
//                 color: colors.surfaceContainerHighest,
//               ),

//               const SizedBox(height: 12),

//               Row(
//                 children: [
//                   _OrderInfo(
//                     icon: Icons.receipt_long_outlined,
//                     text: order.orderNumber,
//                   ),

//                   const SizedBox(width: 14),

//                   _OrderInfo(
//                     icon: Icons.inventory_2_outlined,
//                     text:
//                         '${order.itemsCount} products',
//                   ),

//                   const Spacer(),

//                   Text(
//                     _formatDate(order.createdAt),
//                     style: theme.textTheme.labelSmall?.copyWith(
//                       color: colors.onSurfaceVariant,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =============================================================================
// // INCOMING
// // =============================================================================

// class _IncomingOrdersTab extends StatelessWidget {
//   final OwnerOrdersController controller;

//   const _IncomingOrdersTab({
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (controller.incomingOrders.isEmpty) {
//       return const _OrdersEmptyState(
//         icon: Icons.move_to_inbox_outlined,
//         title: 'No incoming orders',
//         subtitle:
//             'Orders coming from other warehouses will appear here.',
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const _SectionIntro(
//           title: 'Warehouse transfers',
//           subtitle:
//               'Stock coming into this warehouse.',
//         ),

//         const SizedBox(height: 12),

//         ...controller.incomingOrders.map(
//           (order) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: _IncomingOrderCard(
//                 order: order,
//                 onTap: () {
//                   controller.openIncomingOrder(order);
//                 },
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// // =============================================================================
// // INCOMING CARD
// // =============================================================================

// class _IncomingOrderCard extends StatelessWidget {
//   final WarehouseIncomingOrderModel order;
//   final VoidCallback onTap;

//   const _IncomingOrderCard({
//     required this.order,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Material(
//       color: colors.surface,
//       borderRadius: BorderRadius.circular(19),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(19),
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Row(
//             children: [
//               _OrderAvatar(
//                 imageUrl: order.warehouseImageUrl,
//                 icon: Icons.warehouse_outlined,
//               ),

//               const SizedBox(width: 12),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       order.warehouseName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),

//                     const SizedBox(height: 4),

//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           size: 14,
//                           color: colors.onSurfaceVariant,
//                         ),

//                         const SizedBox(width: 3),

//                         Expanded(
//                           child: Text(
//                             order.warehouseLocation,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style:
//                                 theme.textTheme.bodySmall?.copyWith(
//                               color:
//                                   colors.onSurfaceVariant,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 9),

//                     Text(
//                       '${order.totalQuantity} items • ${order.orderNumber}',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style:
//                           theme.textTheme.labelSmall?.copyWith(
//                         color: colors.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 8),

//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 14,
//                     color: colors.onSurfaceVariant,
//                   ),

//                   const SizedBox(height: 8),

//                   Text(
//                     _formatDate(order.expectedDate),
//                     style:
//                         theme.textTheme.labelSmall?.copyWith(
//                       color: colors.primary,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =============================================================================
// // OUTGOING
// // =============================================================================

// class _OutgoingOrdersTab extends StatelessWidget {
//   final OwnerOrdersController controller;

//   const _OutgoingOrdersTab({
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ---------------------------------------------------------------------
//         // BATCH HEADER
//         // ---------------------------------------------------------------------

//         Row(
//           children: [
//             Expanded(
//               child: _SectionIntro(
//                 title: 'Dispatch plan',
//                 subtitle:
//                     'Group accepted orders into outgoing batches.',
//               ),
//             ),

//             const SizedBox(width: 10),

//             Material(
//               color: Theme.of(context)
//                   .colorScheme
//                   .primaryContainer,
//               borderRadius: BorderRadius.circular(12),
//               child: InkWell(
//                 onTap: controller.createBatch,
//                 borderRadius: BorderRadius.circular(12),
//                 child: const Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Icon(
//                     Icons.add_rounded,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 14),

//         // ---------------------------------------------------------------------
//         // BATCHES
//         // ---------------------------------------------------------------------

//         if (controller.outgoingBatches.isNotEmpty) ...[
//           Text(
//             'Outgoing batches',
//             style: Theme.of(context)
//                 .textTheme
//                 .titleSmall
//                 ?.copyWith(
//                   fontWeight: FontWeight.w800,
//                 ),
//           ),

//           const SizedBox(height: 10),

//           ...controller.outgoingBatches.map(
//             (batch) {
//               return Padding(
//                 padding:
//                     const EdgeInsets.only(bottom: 10),
//                 child: _BatchCard(
//                   batch: batch,
//                   onTap: () {
//                     controller.openBatch(batch);
//                   },
//                 ),
//               );
//             },
//           ),

//           const SizedBox(height: 16),
//         ],

//         // ---------------------------------------------------------------------
//         // UNBATCHED ORDERS
//         // ---------------------------------------------------------------------

//         if (controller.outgoingOrders.isEmpty)
//           const _OrdersEmptyState(
//             icon: Icons.local_shipping_outlined,
//             title: 'No outgoing orders',
//             subtitle:
//                 'Accepted orders will appear here for dispatch planning.',
//           )
//         else ...[
//           Text(
//             'Orders waiting for dispatch',
//             style: Theme.of(context)
//                 .textTheme
//                 .titleSmall
//                 ?.copyWith(
//                   fontWeight: FontWeight.w800,
//                 ),
//           ),

//           const SizedBox(height: 10),

//           ...controller.outgoingOrders.map(
//             (order) {
//               return Padding(
//                 padding:
//                     const EdgeInsets.only(bottom: 10),
//                 child: _OutgoingOrderCard(
//                   order: order,
//                   onTap: () {
//                     controller.openOutgoingOrder(order);
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ],
//     );
//   }
// }

// // =============================================================================
// // OUTGOING ORDER CARD
// // =============================================================================

// class _OutgoingOrderCard extends StatelessWidget {
//   final OutgoingOrderModel order;
//   final VoidCallback onTap;

//   const _OutgoingOrderCard({
//     required this.order,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Material(
//       color: colors.surface,
//       borderRadius: BorderRadius.circular(17),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(17),
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Row(
//             children: [
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: colors.primaryContainer,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.local_shipping_outlined,
//                   size: 20,
//                   color: colors.primary,
//                 ),
//               ),

//               const SizedBox(width: 12),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       order.destination,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),

//                     const SizedBox(height: 4),

//                     Text(
//                       order.destinationLocation,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: colors.onSurfaceVariant,
//                       ),
//                     ),

//                     const SizedBox(height: 5),

//                     Text(
//                       '${order.orderNumber} • ${order.totalQuantity} items',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.labelSmall?.copyWith(
//                         color: colors.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 8),

//               _OrderStatus(
//                 status: order.status,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =============================================================================
// // BATCH CARD
// // =============================================================================

// class _BatchCard extends StatelessWidget {
//   final OutgoingBatchModel batch;
//   final VoidCallback onTap;

//   const _BatchCard({
//     required this.batch,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Material(
//       color: colors.surface,
//       borderRadius: BorderRadius.circular(19),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(19),
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: colors.primaryContainer,
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                     child: Icon(
//                       Icons.inventory_outlined,
//                       color: colors.primary,
//                       size: 21,
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           batch.batchNumber,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style:
//                               theme.textTheme.bodyLarge?.copyWith(
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),

//                         const SizedBox(height: 4),

//                         Text(
//                           '${batch.orderCount} orders • ${batch.totalItems} items',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style:
//                               theme.textTheme.bodySmall?.copyWith(
//                             color:
//                                 colors.onSurfaceVariant,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   _BatchStatus(
//                     status: batch.status,
//                   ),

//                   const SizedBox(width: 8),

//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 13,
//                     color: colors.onSurfaceVariant,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 13),

//               Divider(
//                 height: 1,
//                 color: colors.surfaceContainerHighest,
//               ),

//               const SizedBox(height: 11),

//               Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_today_outlined,
//                     size: 14,
//                     color: colors.onSurfaceVariant,
//                   ),

//                   const SizedBox(width: 6),

//                   Text(
//                     'Scheduled ${_formatDate(batch.scheduledDate)}',
//                     style:
//                         theme.textTheme.labelSmall?.copyWith(
//                       color: colors.onSurfaceVariant,
//                     ),
//                   ),

//                   const Spacer(),

//                   Text(
//                     'View batch',
//                     style:
//                         theme.textTheme.labelSmall?.copyWith(
//                       color: colors.primary,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =============================================================================
// // ORDER DETAILS SHEET
// // =============================================================================

// void _showPendingOrderDetails(
//   BuildContext context,
//   OwnerOrdersController controller,
//   ClientOrderModel order,
// ) {
//   final theme = Theme.of(context);
//   final colors = theme.colorScheme;

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: colors.surface,
//     builder: (context) {
//       return SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(
//             20,
//             12,
//             20,
//             20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 38,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: colors.surfaceContainerHighest,
//                     borderRadius:
//                         BorderRadius.circular(10),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 22),

//               Row(
//                 children: [
//                   _OrderAvatar(
//                     imageUrl: order.clientImageUrl,
//                     icon: Icons.person_outline_rounded,
//                   ),

//                   const SizedBox(width: 12),

//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           order.clientName,
//                           style:
//                               theme.textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),

//                         const SizedBox(height: 4),

//                         Text(
//                           order.clientLocation,
//                           maxLines: 1,
//                           overflow:
//                               TextOverflow.ellipsis,
//                           style:
//                               theme.textTheme.bodySmall?.copyWith(
//                             color:
//                                 colors.onSurfaceVariant,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               Row(
//                 children: [
//                   Expanded(
//                     child: _DetailValue(
//                       label: 'Order',
//                       value: order.orderNumber,
//                     ),
//                   ),

//                   Expanded(
//                     child: _DetailValue(
//                       label: 'Products',
//                       value:
//                           order.itemsCount.toString(),
//                     ),
//                   ),

//                   Expanded(
//                     child: _DetailValue(
//                       label: 'Quantity',
//                       value:
//                           order.totalQuantity.toString(),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               Text(
//                 'Order items',
//                 style:
//                     theme.textTheme.titleSmall?.copyWith(
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),

//               const SizedBox(height: 10),

//               ...order.items.map(
//                 (item) {
//                   return Padding(
//                     padding:
//                         const EdgeInsets.only(bottom: 9),
//                     child: Row(
//                       children: [
//                         _OrderAvatar(
//                           imageUrl: item.imageUrl,
//                           icon:
//                               Icons.inventory_2_outlined,
//                           size: 38,
//                         ),

//                         const SizedBox(width: 10),

//                         Expanded(
//                           child: Text(
//                             item.productName,
//                             maxLines: 1,
//                             overflow:
//                                 TextOverflow.ellipsis,
//                             style:
//                                 theme.textTheme.bodySmall
//                                     ?.copyWith(
//                               fontWeight:
//                                   FontWeight.w600,
//                             ),
//                           ),
//                         ),

//                         Text(
//                           '${item.quantity} ${item.unit}',
//                           style:
//                               theme.textTheme.labelMedium
//                                   ?.copyWith(
//                             fontWeight:
//                                 FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 16),

//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         controller.denyOrder(order);
//                       },
//                       style: OutlinedButton.styleFrom(
//                         minimumSize:
//                             const Size.fromHeight(50),
//                         shape:
//                             RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: const Text('Deny'),
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         controller.acceptOrder(order);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         minimumSize:
//                             const Size.fromHeight(50),
//                         backgroundColor:
//                             colors.primary,
//                         foregroundColor:
//                             colors.onPrimary,
//                         elevation: 0,
//                         shape:
//                             RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: const Text(
//                         'Accept order',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// // =============================================================================
// // SMALL WIDGETS
// // =============================================================================

// class _SectionIntro extends StatelessWidget {
//   final String title;
//   final String subtitle;

//   const _SectionIntro({
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.w800,
//           ),
//         ),

//         const SizedBox(height: 3),

//         Text(
//           subtitle,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: theme.textTheme.bodySmall?.copyWith(
//             color: colors.onSurfaceVariant,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _OrderInfo extends StatelessWidget {
//   final IconData icon;
//   final String text;

//   const _OrderInfo({
//     required this.icon,
//     required this.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Flexible(
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 14,
//             color: colors.onSurfaceVariant,
//           ),

//           const SizedBox(width: 5),

//           Flexible(
//             child: Text(
//               text,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style:
//                   Theme.of(context).textTheme.labelSmall,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OrderAvatar extends StatelessWidget {
//   final String? imageUrl;
//   final IconData icon;
//   final double size;

//   const _OrderAvatar({
//     required this.imageUrl,
//     required this.icon,
//     this.size = 48,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     final hasImage =
//         imageUrl != null && imageUrl!.trim().isNotEmpty;

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(13),
//       child: SizedBox(
//         width: size,
//         height: size,
//         child: hasImage
//             ? Image.network(
//                 imageUrl!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) {
//                   return _EmptyAvatar(
//                     icon: icon,
//                   );
//                 },
//               )
//             : _EmptyAvatar(
//                 icon: icon,
//               ),
//       ),
//     );
//   }
// }

// class _EmptyAvatar extends StatelessWidget {
//   final IconData icon;

//   const _EmptyAvatar({
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Container(
//       color:
//           colors.surfaceContainerHighest.withOpacity(0.45),
//       child: Icon(
//         icon,
//         color:
//             colors.onSurfaceVariant.withOpacity(0.5),
//         size: 22,
//       ),
//     );
//   }
// }

// class _OrderStatus extends StatelessWidget {
//   final OrderStatus status;

//   const _OrderStatus({
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     String text;

//     switch (status) {
//       case OrderStatus.accepted:
//         text = 'Accepted';
//         break;
//       case OrderStatus.preparing:
//         text = 'Preparing';
//         break;
//       case OrderStatus.ready:
//         text = 'Ready';
//         break;
//       case OrderStatus.dispatched:
//         text = 'Dispatched';
//         break;
//       case OrderStatus.delivered:
//         text = 'Delivered';
//         break;
//       default:
//         text = 'Pending';
//     }

//     return Text(
//       text,
//       style: Theme.of(context).textTheme.labelSmall?.copyWith(
//         color: colors.primary,
//         fontWeight: FontWeight.w700,
//       ),
//     );
//   }
// }

// class _BatchStatus extends StatelessWidget {
//   final BatchStatus status;

//   const _BatchStatus({
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     String text;

//     switch (status) {
//       case BatchStatus.planned:
//         text = 'Planned';
//         break;
//       case BatchStatus.ready:
//         text = 'Ready';
//         break;
//       case BatchStatus.dispatched:
//         text = 'On the way';
//         break;
//       case BatchStatus.delivered:
//         text = 'Delivered';
//         break;
//     }

//     return Text(
//       text,
//       style: Theme.of(context).textTheme.labelSmall?.copyWith(
//         color: colors.primary,
//         fontWeight: FontWeight.w700,
//       ),
//     );
//   }
// }

// class _DetailValue extends StatelessWidget {
//   final String label;
//   final String value;

//   const _DetailValue({
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style:
//               Theme.of(context).textTheme.labelSmall?.copyWith(
//             color: colors.onSurfaceVariant,
//           ),
//         ),

//         const SizedBox(height: 3),

//         Text(
//           value,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style:
//               Theme.of(context).textTheme.bodyMedium?.copyWith(
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _OrdersEmptyState extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;

//   const _OrdersEmptyState({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 35,
//       ),
//       decoration: BoxDecoration(
//         color: colors.surface,
//         borderRadius: BorderRadius.circular(19),
//       ),
//       child: Column(
//         children: [
//           Icon(
//             icon,
//             size: 38,
//             color:
//                 colors.onSurfaceVariant.withOpacity(0.45),
//           ),

//           const SizedBox(height: 12),

//           Text(
//             title,
//             style: theme.textTheme.bodyLarge?.copyWith(
//               fontWeight: FontWeight.w700,
//             ),
//           ),

//           const SizedBox(height: 5),

//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: theme.textTheme.bodySmall?.copyWith(
//               color: colors.onSurfaceVariant,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =============================================================================
// // DATE
// // =============================================================================

// String _formatDate(DateTime date) {
//   return '${date.day}/${date.month}/${date.year}';
// }