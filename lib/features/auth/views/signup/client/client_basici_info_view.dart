import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:storex/core/routes/app_routes.dart';
import 'package:storex/core/utils/validators.dart';

import 'package:storex/features/auth/controllers/client_signup_controller.dart';
import 'package:storex/features/auth/widgets/login_header.dart';
import 'package:storex/features/auth/widgets/personal_photo_picker.dart';

import 'package:storex/widgets/app_dropdown.dart';
import 'package:storex/widgets/back_button.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class ClientBasicInfoView extends StatelessWidget {
  const ClientBasicInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientSignupController>();

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        body: Stack(
          children: [
            /// BACKGROUND
            Container(
              color: theme.scaffoldBackgroundColor,
            ),

            /// CONTENT
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  padding: EdgeInsets.symmetric(
                    horizontal: media.size.width * 0.05,
                    vertical: media.size.height * 0.02,
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 20,
                        sigmaY: 20,
                      ),

                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.symmetric(
                          horizontal: media.size.width * 0.05,
                          vertical: media.size.height * 0.05,
                        ),

                        decoration: BoxDecoration(
                          color: cs.surface.withValues(alpha: 0.3),

                          borderRadius: BorderRadius.circular(30),

                          border: Border.all(
                            color: cs.onSurface.withValues(alpha: 0.15),
                          ),
                        ),

                        child: Form(
                          key: controller.companyInfoFormKey,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              /// HEADER
                            
                              SizedBox(
                                height: media.size.height * 0.04,
                              ),

                              /// TITLE + PHOTO
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          "Create Account".tr,

                                          style: theme
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontWeight:
                                                    FontWeight.w800,
                                              ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          "Tell us about yourself and your business"
                                              .tr,

                                          style: theme
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: cs.onSurface
                                                    .withOpacity(0.6),

                                                height: 1.4,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  const PersonalPhotoPicker(),
                                ],
                              ),

                              const SizedBox(height: 30),

                              /// FIRST NAME
                              CustomTextField(
                                controller:
                                    controller.firstNameController,

                                label: "First Name".tr,

                                hint: "Enter first name".tr,

                                textInputAction:
                                    TextInputAction.next,

                                validator:
                                    Validators.nameValidation,
                              ),

                              const SizedBox(height: 14),

                              /// LAST NAME
                              CustomTextField(
                                controller:
                                    controller.lastNameController,

                                label: "Last Name".tr,

                                hint: "Enter last name".tr,

                                textInputAction:
                                    TextInputAction.next,

                                validator:
                                    Validators.nameValidation,
                              ),

                              const SizedBox(height: 14),

                              /// USERNAME
                              CustomTextField(
                                controller:
                                    controller.usernameController,

                                label: "Username".tr,

                                hint: "Choose username".tr,

                                textInputAction:
                                    TextInputAction.next,

                                validator:
                                    Validators.usernameValidation,
                              ),

                              const SizedBox(height: 14),

                              /// EMAIL
                              CustomTextField(
                                controller:
                                    controller.emailController,

                                label: "Business Email".tr,

                                hint:
                                    "Enter your business email".tr,

                                keyboardType:
                                    TextInputType.emailAddress,

                                textInputAction:
                                    TextInputAction.next,

                                validator:
                                    Validators.emailValidation,
                              ),

                              const SizedBox(height: 14),

                              /// PHONE
                              CustomTextField(
                                controller:
                                    controller.phoneController,

                                label: "Business Phone".tr,

                                hint: "+963",

                                keyboardType:
                                    TextInputType.phone,

                                textInputAction:
                                    TextInputAction.next,

                                validator:
                                    Validators.phoneValidation,
                              ),

                              const SizedBox(height: 14),

                              /// BUSINESS NAME
                              // CustomTextField(
                              //   controller:
                              //       controller.companyNameController,

                              //   label: "Business Name".tr,

                              //   hint:
                              //       "Enter your business name".tr,

                              //   textInputAction:
                              //       TextInputAction.next,

                              //   validator:
                              //       Validators.required,
                              // ),

                              const SizedBox(height: 14),

                              // /// BUSINESS TYPE
                              // CustomDropdownField<String>(
                              //   label: "Business Type".tr,

                              //   hint:
                              //       "Select business type".tr,

                              //   value: controller
                              //       .selectedBusinessType
                              //       .value,

                              //   items: const [
                              //     DropdownMenuItem(
                              //       value: "retail_store",
                              //       child:
                              //           Text("Retail Store"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "supplier",
                              //       child: Text("Supplier"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "manufacturer",
                              //       child:
                              //           Text("Manufacturer"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "distributor",
                              //       child:
                              //           Text("Distributor"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "wholesaler",
                              //       child:
                              //           Text("Wholesaler"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "import_export",
                              //       child: Text(
                              //         "Import / Export",
                              //       ),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "ecommerce",
                              //       child:
                              //           Text("E-Commerce"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "pharmacy",
                              //       child:
                              //           Text("Pharmacy"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "supermarket",
                              //       child:
                              //           Text("Supermarket"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "restaurant",
                              //       child:
                              //           Text("Restaurant"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "cafe",
                              //       child: Text("Cafe"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "electronics",
                              //       child: Text(
                              //         "Electronics Store",
                              //       ),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "fashion",
                              //       child: Text(
                              //         "Fashion / Clothing",
                              //       ),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "cosmetics",
                              //       child: Text(
                              //         "Cosmetics & Beauty",
                              //       ),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "furniture",
                              //       child:
                              //           Text("Furniture"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "construction",
                              //       child: Text(
                              //         "Construction Materials",
                              //       ),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "automotive",
                              //       child:
                              //           Text("Automotive"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "medical",
                              //       child: Text(
                              //         "Medical Supplies",
                              //       ),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "agriculture",
                              //       child:
                              //           Text("Agriculture"),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "logistics",
                              //       child: Text(
                              //         "Logistics & Shipping",
                              //       ),
                              //     ),

                              //     DropdownMenuItem(
                              //       value: "other",
                              //       child: Text("Other"),
                              //     ),
                              //   ],

                              //   onChanged: (value) {
                              //     controller
                              //         .selectedBusinessType
                              //         .value = value;
                              //   },

                              //   validator: (value) {
                              //     if (value == null ||
                              //         value.isEmpty) {
                              //       return "Please select business type"
                              //           .tr;
                              //     }

                              //     return null;
                              //   },
                              // ),

                              const SizedBox(height: 14),

                            //   /// PASSWORD
                            //   CustomTextField(
                            //     controller:
                            //         controller.passwordController,

                            //     label: "Password".tr,

                            //     hint:
                            //         "Enter your password".tr,

                            //     isPassword: true,

                            //     isObscure: controller
                            //         .isPasswordHidden.value,

                            //     onToggleVisibility: controller
                            //         .togglePasswordVisibility,

                            //     textInputAction:
                            //         TextInputAction.next,

                            //     validator:
                            //         Validators.passwordValidation,
                            //   ),

                            //   const SizedBox(height: 14),

                            //   /// CONFIRM PASSWORD
                            //   CustomTextField(
                            //     controller: controller
                            //         .confirmPasswordController,

                            //     label:
                            //         "Confirm Password".tr,

                            //     hint:
                            //         "Re-enter your password"
                            //             .tr,

                            //     isPassword: true,

                            //  //   isObscure: controller
                            //         .isConfirmPasswordHidden
                            //         .value,

                            //     onToggleVisibility: controller
                            //         .toggleConfirmPasswordVisibility,

                            //     textInputAction:
                            //         TextInputAction.done,

                            //     validator: (value) {
                            //       if (value !=
                            //           controller
                            //               .passwordController
                            //               .text) {
                            //         return "Passwords do not match"
                            //             .tr;
                            //       }

                            //       return null;
                            //     },
                            //   ),

                              SizedBox(
                                height: media.size.height * 0.04,
                              ),

                              /// SIGN UP BUTTON
                              PrimaryButton(
                                text: "Create Account".tr,

                                onPressed: () {
                                  //controller.signUp();
                                },
                              ),

                              /// LOGIN
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,

                                children: [
                                  Text(
                                    "Already have an account?"
                                        .tr,
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Get.offNamed(
                                        AppRoutes.login,
                                      );
                                    },

                                    child: Text(
                                      "Login".tr,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// BACK BUTTON
            const CustomBackButton(),
          ],
        ),
      ),
    );
  }
}