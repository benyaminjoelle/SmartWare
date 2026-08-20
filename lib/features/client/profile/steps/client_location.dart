import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smartware/features/client/profile/controllers/client_location_controller.dart';

class ClientLocation extends StatelessWidget {
  ClientLocation({super.key});

  // ============================================================
  // CONTROLLER
  // ============================================================

  final ClientLocationController controller =
      Get.put<ClientLocationController>(
    ClientLocationController(),
  );

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Size screenSize = MediaQuery.sizeOf(context);

    final double topPadding = MediaQuery.paddingOf(context).top;

    final double availableHeight =
        screenSize.height - topPadding;

    return Scaffold(
      body: Stack(
        children: [
          // ======================================================
          // GOOGLE MAP
          // ======================================================

          Obx(
            () {
              return GoogleMap(
                mapType: MapType.normal,

                initialCameraPosition:
                    ClientLocationController
                        .initialCameraPosition,

                onMapCreated:
                    controller.onMapCreated,

                onTap:
                    controller.selectLocation,

                markers:
                    controller.markers.toSet(),

                // ------------------------------------------------
                // CONTROLS
                // ------------------------------------------------

                myLocationButtonEnabled:
                    false,

                zoomControlsEnabled:
                    false,

                compassEnabled:
                    true,

                mapToolbarEnabled:
                    false,

                // ------------------------------------------------
                // GESTURES
                // ------------------------------------------------

                scrollGesturesEnabled:
                    true,

                zoomGesturesEnabled:
                    true,

                rotateGesturesEnabled:
                    true,

                tiltGesturesEnabled:
                    true,
              );
            },
          ),

          // ======================================================
          // TOP SEARCH AREA
          // ======================================================

          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                0,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  // ==================================================
                  // SEARCH BAR
                  // ==================================================

                  Material(
                    elevation: 5,
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    color:
                        colorScheme.surface,
                    child: TextField(
                      controller:
                          controller.searchController,

                      textInputAction:
                          TextInputAction.search,

                      onChanged:
                          controller.onSearchChanged,

                      onSubmitted: (_) {
                        controller.searchLocation();
                      },

                      decoration:
                          InputDecoration(
                        hintText:
                            'Search location...',

                        prefixIcon:
                            const Icon(
                          Icons.search_rounded,
                        ),

                        suffixIcon:
                            Obx(
                          () {
                            if (controller
                                .isSearching
                                .value) {
                              return const Padding(
                                padding:
                                    EdgeInsets.all(
                                  12,
                                ),
                                child:
                                    SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                  ),
                                ),
                              );
                            }

                            return IconButton(
                              onPressed:
                                  controller
                                      .searchLocation,
                              icon:
                                  const Icon(
                                Icons
                                    .arrow_forward_rounded,
                              ),
                            );
                          },
                        ),

                        filled:
                            true,

                        fillColor:
                            colorScheme.surface,

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // AUTOCOMPLETE
                  // ==================================================

                  Obx(
                    () {
                      if (controller
                          .suggestions
                          .isEmpty) {
                        return const SizedBox.shrink();
                      }

                      // ----------------------------------------------
                      // RESPONSIVE HEIGHT
                      // ----------------------------------------------

                      final double suggestionHeight =
                          (availableHeight * 0.38)
                              .clamp(
                        180.0,
                        300.0,
                      );

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          top: 8,
                        ),

                        constraints:
                            BoxConstraints(
                          maxHeight:
                              suggestionHeight,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              colorScheme.surface,

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black
                                      .withValues(
                                alpha:
                                    0.12,
                              ),
                              blurRadius:
                                  12,
                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child:
                            ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          child:
                              ListView.separated(
                            shrinkWrap:
                                true,

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical:
                                  8,
                            ),

                            itemCount:
                                controller
                                    .suggestions
                                    .length,

                            separatorBuilder:
                                (_, __) {
                              return Divider(
                                height:
                                    1,
                                indent:
                                    56,
                                color:
                                    colorScheme
                                        .outlineVariant,
                              );
                            },

                            itemBuilder:
                                (
                              context,
                              index,
                            ) {
                              final PlacePrediction
                                  suggestion =
                                  controller
                                      .suggestions[
                                index
                              ];

                              return ListTile(
                                contentPadding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      16,
                                  vertical:
                                      4,
                                ),

                                leading:
                                    Container(
                                  width:
                                      40,
                                  height:
                                      40,

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        colorScheme
                                            .primary
                                            .withValues(
                                      alpha:
                                          0.10,
                                    ),
                                    shape:
                                        BoxShape
                                            .circle,
                                  ),

                                  child:
                                      Icon(
                                    Icons
                                        .location_on_outlined,
                                    color:
                                        colorScheme
                                            .primary,
                                  ),
                                ),

                                title:
                                    Text(
                                  suggestion
                                      .description,

                                  maxLines:
                                      2,

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      theme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),

                                trailing:
                                    Icon(
                                  Icons
                                      .arrow_forward_ios_rounded,
                                  size:
                                      15,
                                  color:
                                      colorScheme
                                          .onSurfaceVariant,
                                ),

                                onTap:
                                    () {
                                  controller
                                      .selectSuggestion(
                                    suggestion,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ======================================================
          // SELECTING LOCATION LOADING
          // ======================================================

          Obx(
            () {
              if (!controller
                  .isLoadingPlace
                  .value) {
                return const SizedBox.shrink();
              }

              return Positioned(
                top:
                    MediaQuery.paddingOf(
                          context,
                        ).top +
                        78,

                left:
                    16,

                right:
                    16,

                child:
                    IgnorePointer(
                  child:
                      Center(
                    child:
                        Material(
                      elevation:
                          4,

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),

                      color:
                          colorScheme.surface,

                      child:
                          Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              18,
                          vertical:
                              12,
                        ),

                        child:
                            Row(
                          mainAxisSize:
                              MainAxisSize.min,

                          children: [
                            SizedBox(
                              width:
                                  18,
                              height:
                                  18,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                                color:
                                    colorScheme
                                        .primary,
                              ),
                            ),

                            const SizedBox(
                              width:
                                  10,
                            ),

                            Text(
                              'Finding location...',

                              style:
                                  theme
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                fontWeight:
                                    FontWeight
                                        .w600,
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

          // ======================================================
          // SELECTED LOCATION CARD
          // ======================================================
          //
          // IMPORTANT:
          //
          // This is NO LONGER at bottom: 100.
          //
          // It is placed on the TOP-RIGHT side of the map.
          //
          // This prevents it from fighting with the Done button
          // and reduces collision with the bottom of the screen.
          //
          // ======================================================

          Obx(
            () {
              final LatLng? location =
                  controller
                      .selectedLocation
                      .value;

              if (location == null) {
                return const SizedBox.shrink();
              }

              // ----------------------------------------------
              // Don't show this card while suggestions are open.
              //
              // This is the key part that prevents the visual
              // collision when searching for another location.
              // ----------------------------------------------

              if (controller
                  .suggestions
                  .isNotEmpty) {
                return const SizedBox.shrink();
              }

              final double safeTop =
                  MediaQuery.paddingOf(
                    context,
                  ).top;

              return Positioned(
                top:
                    safeTop + 88,

                right:
                    16,

                left:
                    screenSize.width >
                            600
                        ? screenSize.width *
                                0.48
                            : 16,

                child:
                    Material(
                  elevation:
                      5,

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),

                  color:
                      colorScheme.surface,

                  child:
                      Padding(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),

                    child:
                        Row(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [
                        // ========================================
                        // LOCATION ICON
                        // ========================================

                        Container(
                          width:
                              42,
                          height:
                              42,

                          decoration:
                              BoxDecoration(
                            color:
                                colorScheme
                                    .primary
                                    .withValues(
                              alpha:
                                  0.10,
                            ),
                            shape:
                                BoxShape
                                    .circle,
                          ),

                          child:
                              Icon(
                            Icons
                                .location_on_rounded,
                            color:
                                colorScheme
                                    .primary,
                            size:
                                22,
                          ),
                        ),

                        const SizedBox(
                          width:
                              10,
                        ),

                        // ========================================
                        // ADDRESS
                        // ========================================

                        Expanded(
                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            mainAxisSize:
                                MainAxisSize
                                    .min,

                            children: [
                              Text(
                                'Selected Location',

                                maxLines:
                                    1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style:
                                    theme
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    3,
                              ),

                              Text(
                                controller
                                    .selectedAddress
                                    .value,

                                maxLines:
                                    2,

                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style:
                                    theme
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                  color:
                                      colorScheme
                                          .onSurfaceVariant,
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
            },
          ),

          // ======================================================
          // DONE BUTTON
          // ======================================================

          Positioned(
            left:
                16,

            right:
                16,

            bottom:
                16,

            child:
                SafeArea(
              top:
                  false,

              child:
                  Obx(
                () {
                  final bool saving =
                      controller
                          .isSaving
                          .value;

                  return SizedBox(
                    height:
                        56,

                    child:
                        FilledButton(
                      onPressed:
                          saving
                              ? null
                              : controller
                                  .done,

                      child:
                          saving
                              ? const SizedBox(
                                  width:
                                      22,
                                  height:
                                      22,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                  ),
                                )
                              : const Text(
                                  'Done',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        16,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}