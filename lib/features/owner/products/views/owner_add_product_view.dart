import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/products/controllers/owner_add_product_controller.dart';
import 'package:smartware/features/owner/products/widgets/product_category_selected.dart';

import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<AddProductController>(AddProductController());

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
      

        // ============================================================
        // APP BAR
        // ============================================================

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Add Product',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        // ============================================================
        // BODY
        // ============================================================

        body: SafeArea(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ======================================================
                  // IMAGE
                  // ======================================================

                  Text(
                    'Product Image',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Obx(() {
                    final image = controller.selectedImage.value;

                    return GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 190,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest
                              .withOpacity(.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colors.outline.withOpacity(.15),
                          ),
                        ),
                        child: image == null
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: colors.primary
                                          .withOpacity(.08),
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons
                                          .add_photo_alternate_outlined,
                                      color: colors.primary,
                                      size: 27,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    'Add Product Image',
                                    style: theme
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    'Optional',
                                    style: theme
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color:
                                          colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      image,
                                      fit: BoxFit.cover,
                                    ),

                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Colors.black
                                                .withOpacity(.55),
                                        child: IconButton(
                                          onPressed:
                                              controller.removeImage,
                                          icon: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // ======================================================
                  // SKU
                  // ======================================================

                  CustomTextField(
                    label: 'SKU',
                    hint: 'Enter product SKU',
                    controller: controller.skuController,
                    validator: controller.validateSku,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 18),

                  // ======================================================
                  // NAME
                  // ======================================================

                  CustomTextField(
                    label: 'Product Name',
                    hint: 'Enter product name',
                    controller: controller.nameController,
                    validator: controller.validateName,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 18),

                  // ======================================================
                  // UNIT
                  // ======================================================

                  Text(
                    'Unit',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: controller.selectedUnit.value.isEmpty
                          ? null
                          : controller.selectedUnit.value,
                      decoration: InputDecoration(
                        hintText: 'Select unit',
                        filled: true,
                        fillColor: colors.surfaceContainerHighest
                            .withOpacity(.2),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color:
                                colors.outline.withOpacity(.15),
                          ),
                        ),
                      ),
                      items: controller.units.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: controller.selectUnit,
                    );
                  }),

                  const SizedBox(height: 24),

                  // ======================================================
                  // SECTION ID
                  // ======================================================
CustomTextField(
  label: 'Unit Price',
  hint: 'Enter product unit price',
  controller: controller.unitPriceController,
  validator: controller.validateUnitPrice,
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  textInputAction: TextInputAction.next,
),


                  const SizedBox(height: 18),

                  // ======================================================
                  // QUANTITY
                  // ======================================================

                  CustomTextField(
                    label: 'Quantity',
                    hint: 'Enter initial quantity',
                    controller:
                        controller.quantityController,
                    validator:
                        controller.validateQuantity,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // CATEGORIES
                  // ======================================================
ProductCategorySelector(
  availableCategories: controller.availableCategories,
  isSelected: controller.isCategorySelected,
  onToggle: controller.toggleCategory,
  titleBuilder: controller.categoryTitle,
  iconBuilder: controller.categoryIcon,
),

                  const SizedBox(height: 24),

                  // ======================================================
                  // DESCRIPTION
                  // ======================================================

                  CustomTextField(
                    label: 'Description',
                    hint: 'Describe the product',
                    controller:
                        controller.descriptionController,
                    validator:
                        controller.validateDescription,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),

                  const SizedBox(height: 30),

                  // ======================================================
                  // CREATE PRODUCT
                  // ======================================================

                  Obx(() {
                    return PrimaryButton(
                      text: 'Create Product',
                      isLoading:
                          controller.isLoading.value,

                      onPressed: () async {
                        print('');
                        print(
                          '🚨🚨🚨 CREATE PRODUCT BUTTON PRESSED 🚨🚨🚨',
                        );

                        await controller.createProduct();
                      },
                    );
                  }),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}