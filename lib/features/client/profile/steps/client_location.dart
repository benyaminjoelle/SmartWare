import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartware/features/client/profile/controllers/client_location_controller.dart';
import 'package:smartware/widgets/primary_button.dart';


class ClientLocation extends StatelessWidget {
  ClientLocation({super.key});

  // ============================================================
  // CONTROLLER
  // ============================================================

  final ClientLocationController controller = Get.put<ClientLocationController>(
    ClientLocationController(),
  );

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final safeArea = mediaQuery.padding;

    // ============================================================
    // RESPONSIVE VALUES
    // ============================================================

    final double horizontalPadding = screenSize.width >= 600 ? 24 : 16;

    final double topPadding = safeArea.top + 12;

    // Reserve enough space for:
    //
    // Search bar
    // + spacing
    // + suggestions
    //
    // We intentionally don't allow suggestions to consume
    // the entire screen.
    final double maxSuggestionHeight = (screenSize.height * 0.40).clamp(
      160.0,
      280.0,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        fit: StackFit.expand,
        children: [
          // ======================================================
          // GOOGLE MAP
          // ======================================================
          Obx(() {
            return GoogleMap(
              mapType: MapType.normal,

              initialCameraPosition:
                  ClientLocationController.initialCameraPosition,

              onMapCreated: controller.onMapCreated,

              onTap: controller.selectLocation,

              markers: controller.markers.toSet(),

              // ------------------------------------------------
              // CONTROLS
              // ------------------------------------------------
              myLocationButtonEnabled: false,

              zoomControlsEnabled: false,

              compassEnabled: true,

              mapToolbarEnabled: false,

              // ------------------------------------------------
              // GESTURES
              // ------------------------------------------------
              scrollGesturesEnabled: true,

              zoomGesturesEnabled: true,

              rotateGesturesEnabled: true,

              tiltGesturesEnabled: true,
            );
          }),

          // ======================================================
          // SEARCH BAR
          // ======================================================
          //
          // IMPORTANT:
          //
          // The search bar is now independent from the
          // suggestions list.
          //
          // We do NOT put them inside one Column anymore.
          //
          // This completely removes the RenderFlex overflow.
          // ======================================================
          Positioned(
            top: topPadding,
            left: horizontalPadding,
            right: horizontalPadding,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(18),
              color: colorScheme.surface,
              clipBehavior: Clip.antiAlias,
              child: TextField(
                controller: controller.searchController,

                textInputAction: TextInputAction.search,

                onChanged: controller.onSearchChanged,

                onSubmitted: (_) {
                  controller.searchLocation();
                },

                decoration: InputDecoration(
                  hintText: 'Search location...',

                  prefixIcon: const Icon(Icons.search_rounded),

                  suffixIcon: Obx(() {
                    if (controller.isSearching.value) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    return IconButton(
                      onPressed: controller.searchLocation,
                      icon: const Icon(Icons.arrow_forward_rounded),
                    );
                  }),

                  filled: true,

                  fillColor: colorScheme.surface,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          // ======================================================
          // AUTOCOMPLETE SUGGESTIONS
          // ======================================================
          //
          // This is now a Positioned widget.
          //
          // It is no longer a child of the search Column.
          //
          // Therefore:
          //
          // Search bar height
          // + suggestions height
          //
          // can never create a RenderFlex overflow.
          // ======================================================
          Obx(() {
            if (controller.suggestions.isEmpty) {
              return const SizedBox.shrink();
            }

            return Positioned(
              top: topPadding + 64,
              left: horizontalPadding,
              right: horizontalPadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxSuggestionHeight),
                child: Material(
                  elevation: 5,
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  clipBehavior: Clip.antiAlias,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),

                    // IMPORTANT:
                    //
                    // shrinkWrap is not necessary here because
                    // the parent already gives the ListView a
                    // maximum height.
                    //
                    // Keeping it false allows the ListView to
                    // scroll normally.
                    shrinkWrap: false,

                    physics: const ClampingScrollPhysics(),

                    itemCount: controller.suggestions.length,

                    separatorBuilder: (_, __) {
                      return Divider(
                        height: 1,
                        indent: 56,
                        color: colorScheme.outlineVariant,
                      );
                    },

                    itemBuilder: (context, index) {
                      final PlacePrediction suggestion =
                          controller.suggestions[index];

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),

                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: colorScheme.primary,
                          ),
                        ),

                        title: Text(
                          suggestion.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),

                        onTap: () {
                          controller.selectSuggestion(suggestion);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          }),

          // ======================================================
          // SELECTING LOCATION LOADING
          // ======================================================
          Obx(() {
            if (!controller.isLoadingPlace.value) {
              return const SizedBox.shrink();
            }

            return Positioned(
              top: safeArea.top + 78,
              left: horizontalPadding,
              right: horizontalPadding,
              child: IgnorePointer(
                child: Center(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(30),
                    color: colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            'Finding location...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // ======================================================
          // SELECTED LOCATION CARD
          // ======================================================
          Obx(() {
            final LatLng? location = controller.selectedLocation.value;

            if (location == null) {
              return const SizedBox.shrink();
            }

            // Don't show the selected location card while
            // autocomplete suggestions are visible.
            if (controller.suggestions.isNotEmpty) {
              return const SizedBox.shrink();
            }

            final double selectedCardTop = safeArea.top + 88;

            // On small screens:
            //
            // left = 16
            // right = 16
            //
            // On larger screens:
            //
            // the card occupies the right side.
            final bool isTablet = screenSize.width >= 600;

            return Positioned(
              top: selectedCardTop,

              left: isTablet ? screenSize.width * 0.48 : horizontalPadding,

              right: horizontalPadding,

              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(18),
                color: colorScheme.surface,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ========================================
                      // LOCATION ICON
                      // ========================================
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: colorScheme.primary,
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // ========================================
                      // ADDRESS
                      // ========================================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Selected Location',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              controller.selectedAddress.value,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // ======================================================
          // DONE BUTTON
          // ======================================================
        // final bool saving = controller.isSaving.value;
          Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: 16,
          child: SafeArea(
            top: false,
            child: Obx(() {
              return PrimaryButton(
                text: 'Done',
                isLoading: controller.isSaving.value,
                onPressed: controller.done,
              );
            }),
          ),
        ),
                    
      ]),
    );
  }
}
