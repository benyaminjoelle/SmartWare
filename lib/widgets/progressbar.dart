// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../features/auth/controllers/client_signup_controller.dart';

// class SignupProgressBar extends StatelessWidget {
//   const SignupProgressBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ClientSignupController>();

//     final theme = Theme.of(context);
//     final cs = theme.colorScheme;

//     return Obx(() {
//       final current = controller.currentStep.value;
//       final total = controller.totalSteps;

//       final active = cs.primary;
//       final done = cs.primary.withOpacity(0.6);
//       final pending = cs.outline.withOpacity(0.25);

//       return SizedBox(
//         width: double.infinity,

//         child: Row(
//           children: List.generate(total * 2 - 1, (i) {
//             /// STEP CIRCLE
//             if (i.isEven) {
//               final index = i ~/ 2;

//               final isDone = index < current;
//               final isActive = index == current;

//               return Container(
//                 width: 34,
//                 height: 34,

//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,

//                   color: isDone
//                       ? done.withOpacity(0.15)
//                       : isActive
//                           ? active
//                           : Colors.transparent,

//                   border: Border.all(
//                     color: isDone
//                         ? done
//                         : isActive
//                             ? active
//                             : pending,
//                     width: isActive ? 2 : 1.2,
//                   ),
//                 ),

//                 child: Center(
//                   child: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 200),

//                     child: isDone
//                         ? Icon(
//                             Icons.check_rounded,
//                             key: ValueKey("check$index"),
//                             size: 18,
//                             color: done,
//                           )
//                         : Text(
//                             "${index + 1}",
//                             key: ValueKey("num$index"),
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: isActive
//                                   ? Colors.white
//                                   : cs.onSurface.withOpacity(0.6),
//                             ),
//                           ),
//                   ),
//                 ),
//               );
//             }

//             /// CONNECTOR LINE
//             final connectorIndex = (i - 1) ~/ 2;

//             return Expanded(
//               child: Container(
//                 height: 3,
//                 margin: const EdgeInsets.symmetric(horizontal: 8),

//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),

//                   color: connectorIndex < current
//                       ? done
//                       : pending,
//                 ),
//               ),
//             );
//           }),
//         ),
//       );
//     });
//   }
// }