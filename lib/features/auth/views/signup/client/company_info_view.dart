import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/controllers/client_signup_controller.dart';
import 'package:storex/widgets/app_dropdown.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class CompanyInfoView extends StatelessWidget {
  const CompanyInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientSignupController>();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 600;

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),

                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),

                  child: Align(
                    alignment: Alignment.topCenter,

                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 520 : double.infinity,
                      ),

                      child: Form(
                        key: controller.companyInfoFormKey,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// HEADER
                            Text(
                              "Business Information".tr,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Tell us about your business so we can set things up properly"
                                  .tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurface.withOpacity(0.6),
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// COMPANY NAME
                            CustomTextField(
                              //controller: controller.companyNameController,
                              label: "Business Name".tr,
                              hint: "Enter your business name".tr,
                              textInputAction: TextInputAction.next,
                             // validator: Validators.required,
                            ),

                            const SizedBox(height: 14),
Obx(
  ()=>
  CustomDropdownField<String>(
    
    label: "Business Type".tr,
    hint: "Select business type".tr,
  
    value: controller.selectedBusinessType.value,
  
    items: const [
    
  
    DropdownMenuItem(
      value: "retail_store",
      child: Text("Retail Store"),
    ),
  
    DropdownMenuItem(
      value: "supplier",
      child: Text("Supplier"),
    ),
  
    DropdownMenuItem(
      value: "manufacturer",
      child: Text("Manufacturer"),
    ),
  
    DropdownMenuItem(
      value: "distributor",
      child: Text("Distributor"),
    ),
  
    DropdownMenuItem(
      value: "wholesaler",
      child: Text("Wholesaler"),
    ),
  
    DropdownMenuItem(
      value: "import_export",
      child: Text("Import / Export"),
    ),
  
    DropdownMenuItem(
      value: "ecommerce",
      child: Text("E-Commerce"),
    ),
  
    DropdownMenuItem(
      value: "pharmacy",
      child: Text("Pharmacy"),
    ),
  
    DropdownMenuItem(
      value: "supermarket",
      child: Text("Supermarket"),
    ),
  
    DropdownMenuItem(
      value: "restaurant",
      child: Text("Restaurant"),
    ),
  
    DropdownMenuItem(
      value: "cafe",
      child: Text("Cafe"),
    ),
  
    DropdownMenuItem(
      value: "electronics",
      child: Text("Electronics Store"),
    ),
  
    DropdownMenuItem(
      value: "fashion",
      child: Text("Fashion / Clothing"),
    ),
  
    DropdownMenuItem(
      value: "cosmetics",
      child: Text("Cosmetics & Beauty"),
    ),
  
    DropdownMenuItem(
      value: "furniture",
      child: Text("Furniture"),
    ),
  
    DropdownMenuItem(
      value: "construction",
      child: Text("Construction Materials"),
    ),
  
    DropdownMenuItem(
      value: "automotive",
      child: Text("Automotive"),
    ),
  
    DropdownMenuItem(
      value: "medical",
      child: Text("Medical Supplies"),
    ),
  
    DropdownMenuItem(
      value: "agriculture",
      child: Text("Agriculture"),
    ),
  
    DropdownMenuItem(
      value: "logistics",
      child: Text("Logistics & Shipping"),
    ),
  
    DropdownMenuItem(
      value: "other",
      child: Text("Other"),
    ),
  ],
  
    onChanged: (value) {
      controller.selectedBusinessType.value = value;
    },
  
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Please select business type".tr;
      }
  
      return null;
    },
  
  ),
),

                            const SizedBox(height: 14),

                            

                            /// COMPANY EMAIL
                            CustomTextField(
                             // controller: controller.companyEmailController,
                              label: "Business Email".tr,
                              hint: "Enter your business Email",
                              textInputAction: TextInputAction.next,
                              validator: Validators.emailValidation,
                            ),

                            const SizedBox(height: 14),

                            /// COMPANY PHONE
                            CustomTextField(
                            //  controller: controller.companyPhoneController,
                              label: "Business Phone".tr,
                            
                              hint: "+963",
                              textInputAction: TextInputAction.done,
                              validator: Validators.phoneValidation,
                            ),

                            const SizedBox(height: 30),

                            /// CONTINUE BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                onPressed: controller.nextStep,
                                text: "Continue".tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}