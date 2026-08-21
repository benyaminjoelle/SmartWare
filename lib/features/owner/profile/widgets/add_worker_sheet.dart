import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/profile/controllers/owner_workers_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';

void showAddWorkerSheet({
  required BuildContext context,
  required OwnerWorkersController controller,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => AddWorkerSheet(
      controller: controller,
    ),
  );
}

class AddWorkerSheet extends StatefulWidget {
  final OwnerWorkersController controller;

  const AddWorkerSheet({
    super.key,
    required this.controller,
  });

  @override
  State<AddWorkerSheet> createState() =>
      _AddWorkerSheetState();
}

class _AddWorkerSheetState
    extends State<AddWorkerSheet> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController nationalIdController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController();

    lastNameController =
        TextEditingController();

    nationalIdController =
        TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nationalIdController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // ADD WORKER
  // ===========================================================================

  Future<void> _addWorker() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final success =
        await widget.controller.addWorker(
      firstName:
          firstNameController.text.trim(),
      lastName:
          lastNameController.text.trim(),
      nationalId:
          nationalIdController.text.trim(),
    );

    // Only close the sheet if the API succeeded.
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet =
            constraints.maxWidth >= 600;

        final sidePadding =
            isTablet ? 32.0 : 20.0;

        return Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),

          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                sidePadding,
                12,
                sidePadding,
                mediaQuery.viewInsets.bottom + 20,
              ),

              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,

                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(
                      maxWidth: 650,
                    ),

                    child: Form(
                      key: formKey,

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const _SheetHandle(),

                          const SizedBox(height: 24),

                          Text(
                            'Add Worker',
                            style: theme
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Enter the worker information. The worker will remain pending until they register their account.',
                            style: theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 24),

                          CustomTextField(
                            controller:
                                firstNameController,
                            label: 'First Name',
                            hint:
                                'Enter first name',
                          ),

                          const SizedBox(height: 14),

                          CustomTextField(
                            controller:
                                lastNameController,
                            label: 'Last Name',
                            hint:
                                'Enter last name',
                          ),

                          const SizedBox(height: 14),

                          CustomTextField(
                            controller:
                                nationalIdController,
                            label:
                                'National ID Number',
                            hint:
                                'Enter national ID number',
                            keyboardType:
                                TextInputType.number,
                          ),

                          const SizedBox(height: 24),

                          // ====================================================
                          // ADD BUTTON
                          // ====================================================

                          Obx(
                            () {
                              final isLoading =
                                  widget.controller
                                      .isLoading.value;

                              return SizedBox(
                                width: double.infinity,
                                child:
                                    FilledButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : _addWorker,

                                  icon: isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons
                                              .person_add_alt_1_rounded,
                                        ),

                                  label: Text(
                                    isLoading
                                        ? 'Adding...'
                                        : 'Add Worker',
                                  ),

                                  style:
                                      FilledButton
                                          .styleFrom(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      vertical: 15,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        13,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// SHEET HANDLE
// =============================================================================

class _SheetHandle
    extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: colorScheme
              .onSurfaceVariant
              .withValues(alpha: .25),
          borderRadius:
              BorderRadius.circular(10),
        ),
      ),
    );
  }
}