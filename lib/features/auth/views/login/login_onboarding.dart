// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:smartware/features/auth/controllers/login_o_controller.dart';
// import 'package:smartware/features/auth/widgets/role_data.dart';
// import '../../widgets/role_card.dart';
// import '../../widgets/login_onboarding_header.dart';


// class LoginOnboarding extends StatelessWidget {
//   LoginOnboarding({super.key});

//   // final controller = Get.put(LoginOnboardingController());

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final roles = getRoles(colors);

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔙 Back button removed intentionally for cleaner UX (optional)
//               const SizedBox(height: 10),

//               // 🧠 Header (smartware + text)
//               const LoginOnboardingHeader(),

//               const SizedBox(height: 25),

//               // 🎯 Roles grid
//               Expanded(
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     final isTablet = constraints.maxWidth > 600;

//                     return GridView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: roles.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: isTablet ? 2 : 1,
//                         childAspectRatio: 3.6,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                       ),
//                       itemBuilder: (context, index) {
//                         final role = roles[index];

//                         return Obx(() {
//                           return RoleCard(
//                             title: role.title,
//                             description: role.description,
//                             icon: role.icon,
//                             color: role.color,
//                             isSelected: controller.isSelected(role.title),
//                             onTap: () => controller.selectRole(role.title),
//                           );
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),

//               // 🧾 Sign up CTA
//               Center(
//                 child: TextButton(
//                   onPressed: () {
//                     // Get.toNamed('/signup');
//                   },
//                   child: Text(
//                     "Don't have an account? Sign up",
//                     style: TextStyle(color: colors.onSurface),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }