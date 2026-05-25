import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/auth/controllers/client_signup_controller.dart';
import 'package:storex/features/auth/views/signup/client/account_info_view.dart';
import 'package:storex/features/auth/views/signup/client/client_basici_info_view.dart';
import 'package:storex/features/auth/views/signup/client/documents_view.dart';
import 'package:storex/features/auth/widgets/signup_progressbar.dart';
import 'package:storex/widgets/back_button.dart';

class ClientSignupShell extends StatelessWidget {
  ClientSignupShell({super.key});

  final controller = Get.put(ClientSignupController());

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 550 : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  /// SINGLE SMART BACK BUTTON
                  CustomBackButton(
                    onPressed: controller.handleBack,
                  ),

                  const SizedBox(height: 10),
                  const SizedBox(height: 28),

                  /// progress
                  const SignupProgressBar(),

                  const SizedBox(height: 28),

                  /// pages
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        ClientBasicInfoView(),
                        AccountInfoView(),
                        DocumentsView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}