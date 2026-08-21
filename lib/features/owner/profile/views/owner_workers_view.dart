import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/profile/controllers/owner_workers_controller.dart';
import 'package:smartware/features/owner/profile/widgets/add_worker_sheet.dart';
import 'package:smartware/features/owner/profile/widgets/empty_worker_state.dart';
import 'package:smartware/features/owner/profile/widgets/worker_card.dart';
import 'package:smartware/widgets/app_dialog.dart';

class OwnerWorkersView extends StatelessWidget {
  const OwnerWorkersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OwnerWorkersController(),
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final isTablet = width >= 600;
            final isDesktop = width >= 1000;

            final horizontalPadding = isDesktop
                ? 40.0
                : isTablet
                    ? 32.0
                    : 16.0;

            return Obx(
              () => Column(
                children: [
                  _WorkersHeader(
                    controller: controller,
                    horizontalPadding:
                        horizontalPadding,
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 1100,
                        ),
                        child: controller
                                .filteredWorkers
                                .isEmpty
                            ? EmptyWorkersState(
                                hasSearch: controller
                                    .searchQuery
                                    .value
                                    .isNotEmpty,
                              )
                            : ListView.separated(
                                physics:
                                    const BouncingScrollPhysics(),
                                padding:
                                    EdgeInsets.fromLTRB(
                                  horizontalPadding,
                                  0,
                                  horizontalPadding,
                                  110,
                                ),
                                itemCount: controller
                                    .filteredWorkers
                                    .length,
                                separatorBuilder:
                                    (_, __) =>
                                        const SizedBox(
                                  height: 12,
                                ),
                                itemBuilder:
                                    (context, index) {
                                  final worker =
                                      controller
                                          .filteredWorkers[
                                              index];

                                  return WorkerCard(
                                    worker: worker,
                                    onRemove:
                                        () async {
                                      final confirmed =
                                          await AppDialogs
                                              .showConfirmDialog(
                                        title:
                                            'Remove Worker?',
                                        message:
                                            'Are you sure you want to remove ${worker.fullName} from your warehouse team?',
                                        confirmText:
                                            'Remove',
                                        cancelText:
                                            'Cancel',
                                      );

                                      if (confirmed ==
                                          true) {
                                        controller
                                            .removeWorker(
                                          worker,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  showAddWorkerSheet(
                    context: context,
                    controller: controller,
                  );
                },
          icon: const Icon(
            Icons.person_add_alt_1_rounded,
          ),
          label: const Text(
            'Add Worker',
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

class _WorkersHeader extends StatelessWidget {
  final OwnerWorkersController controller;
  final double horizontalPadding;

  const _WorkersHeader({
    required this.controller,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        8,
        horizontalPadding,
        0,
      ),
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(
          maxWidth: 1100,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BackButton(),

                const SizedBox(width: 4),

                Expanded(
                  child: Text(
                    'My Workers',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding:
                  const EdgeInsets.only(
                left: 48,
              ),
              child: Text(
                'Add, manage, and remove workers who have access to your warehouse.',
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: colorScheme
                      .onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  controller.searchController,
              onChanged:
                  controller.updateSearch,
              textInputAction:
                  TextInputAction.search,
              decoration:
                  InputDecoration(
                hintText:
                    'Search workers...',

                prefixIcon:
                    const Icon(
                  Icons.search_rounded,
                ),

                suffixIcon:
                    controller.searchQuery
                            .value
                            .isNotEmpty
                        ? IconButton(
                            onPressed:
                                controller
                                    .clearSearch,
                            icon:
                                const Icon(
                              Icons
                                  .close_rounded,
                            ),
                          )
                        : null,

                filled: true,

                fillColor: colorScheme
                    .surfaceContainerHighest
                    .withValues(
                  alpha: .45,
                ),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(14),
                  borderSide:
                      BorderSide.none,
                ),

                contentPadding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}