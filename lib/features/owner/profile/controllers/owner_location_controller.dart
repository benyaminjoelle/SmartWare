import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/features/owner/profile/models/owner_onboarding_repo.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class OwnerLocationController extends GetxController {

  final OwnerOnboardingRepo _repo = OwnerOnboardingRepo(); 
   // GOOGLE API KEY
  static const String googleApiKey =
      'AIzaSyCl0f-cxl8M8p8HzCpXIk4rBG-GFdiZBjs';
  // GOOGLE PLACES URLS
  static const String _autocompleteUrl =
      'https://places.googleapis.com/v1/places:autocomplete';

  static const String _placesUrl =
      'https://places.googleapis.com/v1/places';
  // DIO
  final Dio _dio = Dio();
  // MAP CONTROLLER  //
  // IMPORTANT:
  // We do NOT use Completer here.
  //
  // A Completer can keep an old GoogleMapController after the
  // GoogleMap widget has been disposed/recreated.
  //
  // A nullable controller is safer because we can explicitly
  // clear it when the controller is disposed.
  //
  GoogleMapController? _mapController;
  // SEARCH CONTROLLER
  final TextEditingController searchController =
      TextEditingController();
  // SEARCH DEBOUNCE
  Timer? _searchDebounce;
  // GOOGLE PLACES SESSION TOKEN
  String sessionToken = '';
  // AUTOCOMPLETE SUGGESTIONS
  final RxList<PlacePrediction> suggestions =
      <PlacePrediction>[].obs;
  // SELECTED LOCATION
  final Rxn<LatLng> selectedLocation =
      Rxn<LatLng>();

  final RxString selectedAddress =
      ''.obs;
  // LOADING STATES
  final RxBool isSearching =
      false.obs;

  final RxBool isLoadingPlace =
      false.obs;

  final RxBool isSaving =
      false.obs;
  // MARKERS
  final RxSet<Marker> markers =
      <Marker>{}.obs;
  // SYRIA CENTER
  static const LatLng syriaCenter =
      LatLng(
    34.8021,
    38.9968,
  );
  // INITIAL CAMERA
  static const CameraPosition initialCameraPosition =
      CameraPosition(
    target: syriaCenter,
    zoom: 6.5,
  );
  // INIT
  @override
  void onInit() {
    super.onInit();

    sessionToken = _generateSessionToken();

    debugPrint(
      '📍 ClientLocationController initialized',
    );

    debugPrint(
      '🎫 Places session token created',
    );
  }
  // GENERATE SESSION TOKEN
  String _generateSessionToken() {
    final random = Random.secure();

    return List.generate(
      32,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
  }
  // MAP CREATED
  void onMapCreated(
    GoogleMapController controller,
  ) {
    _mapController = controller;

    debugPrint(
      '🗺️ Google Map controller created',
    );
  }
  // SEARCH CHANGED
  void onSearchChanged(String value) {
    final query = value.trim();

    _searchDebounce?.cancel();

    // ----------------------------------------------------------
    // EMPTY SEARCH
    // ----------------------------------------------------------

    if (query.isEmpty) {
      suggestions.clear();
      isSearching.value = false;
      return;
    }

    // ----------------------------------------------------------
    // MINIMUM TWO CHARACTERS
    // ----------------------------------------------------------

    if (query.length < 2) {
      suggestions.clear();
      isSearching.value = false;
      return;
    }

    // ----------------------------------------------------------
    // DEBOUNCE
    // ----------------------------------------------------------

    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
      () {
        _searchAutocomplete(query);
      },
    );
  }
  // GOOGLE PLACES AUTOCOMPLETE
  Future<void> _searchAutocomplete(
    String query,
  ) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return;
    }

    try {
      isSearching.value = true;

      debugPrint(
        '════════ GOOGLE PLACES AUTOCOMPLETE ════════',
      );

      debugPrint(
        '🔎 Query: $trimmedQuery',
      );

      debugPrint(
        '🎫 Session Token: $sessionToken',
      );

      final response = await _dio.post(
        _autocompleteUrl,
        data: {
          'input': trimmedQuery,
          'sessionToken': sessionToken,
          'includedRegionCodes': ['SY'],
          'languageCode': 'ar',
          'regionCode': 'SY',
          'includeQueryPredictions': true,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': googleApiKey,
            'X-Goog-FieldMask':
                'suggestions.placePrediction.place,'
                'suggestions.placePrediction.placeId,'
                'suggestions.placePrediction.text,'
                'suggestions.placePrediction.structuredFormat',
          },
        ),
      );

      debugPrint(
        '✅ Places status: ${response.statusCode}',
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        suggestions.clear();
        return;
      }

      final List<dynamic> rawSuggestions =
          data['suggestions'] is List
              ? data['suggestions']
              : <dynamic>[];

      final List<PlacePrediction> results =
          <PlacePrediction>[];

      // ========================================================
      // PARSE RESULTS
      // ========================================================

      for (final item in rawSuggestions) {
        if (item is! Map) {
          continue;
        }

        final prediction =
            item['placePrediction'];

        if (prediction is! Map) {
          continue;
        }

        final String placeId =
            prediction['placeId']?.toString() ?? '';

        if (placeId.isEmpty) {
          continue;
        }

        // ------------------------------------------------------
        // DESCRIPTION
        // ------------------------------------------------------

        String description = '';

        final text = prediction['text'];

        if (text is Map) {
          description =
              text['text']?.toString() ?? '';
        }

        // ------------------------------------------------------
        // STRUCTURED FORMAT
        // ------------------------------------------------------

        String mainText = description;
        String secondaryText = '';

        final structuredFormat =
            prediction['structuredFormat'];

        if (structuredFormat is Map) {
          final main =
              structuredFormat['mainText'];

          if (main is Map) {
            mainText =
                main['text']?.toString() ??
                    description;
          }

          final secondary =
              structuredFormat['secondaryText'];

          if (secondary is Map) {
            secondaryText =
                secondary['text']?.toString() ??
                    '';
          }
        }

        // ------------------------------------------------------
        // PLACE RESOURCE
        // ------------------------------------------------------

        final String placeResourceName =
            prediction['place']?.toString() ?? '';

        results.add(
          PlacePrediction(
            placeId: placeId,
            placeResourceName:
                placeResourceName,
            description: description,
            mainText: mainText,
            secondaryText: secondaryText,
          ),
        );
      }

      suggestions.assignAll(results);

      debugPrint(
        '📍 Suggestions found: ${results.length}',
      );

      debugPrint(
        '════════════════════════════════════════',
      );
    } on DioException catch (e) {
      debugPrint(
        '❌ Google Places Dio error: ${e.message}',
      );

      debugPrint(
        '❌ Status: ${e.response?.statusCode}',
      );

      debugPrint(
        '❌ Response: ${e.response?.data}',
      );

      suggestions.clear();
    } catch (e) {
      debugPrint(
        '❌ Google Places error: $e',
      );

      suggestions.clear();
    } finally {
      isSearching.value = false;
    }
  }
  // SELECT AUTOCOMPLETE SUGGESTION
  Future<void> selectSuggestion(
    PlacePrediction prediction,
  ) async {
    if (isLoadingPlace.value) {
      return;
    }

    try {
      isLoadingPlace.value = true;

      debugPrint(
        '════════ PLACE SELECTED ════════',
      );

      debugPrint(
        '📍 Name: ${prediction.description}',
      );

      debugPrint(
        '🆔 Place ID: ${prediction.placeId}',
      );

      // ========================================================
      // UPDATE SEARCH FIELD
      // ========================================================

      searchController.text =
          prediction.description;

      searchController.selection =
          TextSelection.fromPosition(
        TextPosition(
          offset: searchController.text.length,
        ),
      );

      // ========================================================
      // CLEAR SUGGESTIONS
      // ========================================================

      suggestions.clear();

      // ========================================================
      // GET COORDINATES
      // ========================================================

      final LatLng? location =
          await _getPlaceLocation(
        prediction.placeId,
      );

      if (location == null) {
        Get.snackbar(
          'Location Error',
          'Could not get the coordinates of this location.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      // ========================================================
      // SAVE SELECTED LOCATION
      // ========================================================

      selectedLocation.value = location;

      // ========================================================
      // SAVE ADDRESS
      // ========================================================

      if (selectedAddress.value.isEmpty) {
        selectedAddress.value =
            prediction.description;
      }

      // ========================================================
      // SET MARKER
      // ========================================================

      _setMarker(
        location,
        title: prediction.mainText,
        snippet: prediction.secondaryText,
      );

      // ========================================================
      // MOVE CAMERA
      // ========================================================

      await moveCamera(location);

      debugPrint('📍 Latitude: ${location.latitude}',);
      debugPrint('📍 Longitude: ${location.longitude}',);
      debugPrint('📍 Address: ${selectedAddress.value}',);

      debugPrint(
        '════════════════════════════════',
      );

      // ========================================================
      // CREATE NEW SESSION
      // ========================================================

      sessionToken =
          _generateSessionToken();
    } catch (e) {
      debugPrint(
        '❌ Select place error: $e',
      );

      Get.snackbar(
        'Error',
        'Unable to select this location.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingPlace.value = false;
    }
  }
  
  // GET PLACE DETAILS
  Future<LatLng?> _getPlaceLocation(
    String placeId,
  ) async {
    try {
      debugPrint(
        '🔎 Getting place details...',
      );

      final response = await _dio.get(
        '$_placesUrl/$placeId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': googleApiKey,
            'X-Goog-FieldMask':
                'id,displayName,formattedAddress,location',
          },
        ),
      );

      debugPrint(
        '✅ Place Details: ${response.statusCode}',
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        return null;
      }

      // ========================================================
      // LOCATION
      // ========================================================

      final location = data['location'];

      if (location is! Map) {
        return null;
      }

      final double? latitude =
          (location['latitude'] as num?)?.toDouble();

      final double? longitude =
          (location['longitude'] as num?)?.toDouble();

      if (latitude == null ||
          longitude == null) {
        return null;
      }

      // ========================================================
      // FORMATTED ADDRESS
      // ========================================================

      final String formattedAddress =
          data['formattedAddress']?.toString() ?? '';

      if (formattedAddress.isNotEmpty) {
        selectedAddress.value =
            formattedAddress;
      }

      return LatLng(
        latitude,
        longitude,
      );
    } on DioException catch (e) {
      debugPrint(
        '❌ Place Details Dio error: ${e.message}',
      );

      debugPrint(
        '❌ Status: ${e.response?.statusCode}',
      );

      debugPrint(
        '❌ Response: ${e.response?.data}',
      );

      return null;
    } catch (e) {
      debugPrint(
        '❌ Place Details error: $e',
      );

      return null;
    }
  }
  // SELECT LOCATION DIRECTLY FROM MAP
  Future<void> selectLocation(
    LatLng location,
  ) async {
    debugPrint(
      '📍 Map location selected:',
    );

    debugPrint(
      '   Latitude: ${location.latitude}',
    );

    debugPrint(
      '   Longitude: ${location.longitude}',
    );

    selectedLocation.value = location;

    selectedAddress.value =
        '${location.latitude.toStringAsFixed(6)}, '
        '${location.longitude.toStringAsFixed(6)}';

    _setMarker(
      location,
      title: 'Selected Location',
      snippet: selectedAddress.value,
    );

    // The map was already tapped at this position,
    // so there is no need to animate the camera.
  }
  // SET MARKER
  void _setMarker(
    LatLng location, {
    required String title,
    String? snippet,
  }) {
    markers.value = {
      Marker(
        markerId: const MarkerId(
          'selected_location',
        ),
        position: location,
        infoWindow: InfoWindow(
          title: title,
          snippet: snippet,
        ),
      ),
    };
  }
    // MOVE CAMERA  //
  // This is the important part.
  //
  // We use the CURRENT GoogleMapController.
  //
  // No Completer.
  // No second map.
  // No stale controller.
  //
  Future<void> moveCamera(
    LatLng location,
  ) async {
    final GoogleMapController? controller =
        _mapController;

    if (controller == null) {
      debugPrint(
        '⚠️ Cannot move camera: map controller is null.',
      );

      return;
    }

    try {
      debugPrint(
        '📷 Moving camera...',
      );

      debugPrint(
        '📍 Target: '
        '${location.latitude}, '
        '${location.longitude}',
      );

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 15,
          ),
        ),
      );

      debugPrint(
        '✅ Camera moved successfully',
      );
    } catch (e) {
      debugPrint(
        '❌ Camera movement error: $e',
      );
    }
  }
  // SEARCH LOCATION BUTTON
  Future<void> searchLocation() async {
    final query =
        searchController.text.trim();

    if (query.isEmpty) {
      return;
    }

    // ----------------------------------------------------------
    // If suggestions exist, let the user select one.
    // ----------------------------------------------------------

    if (suggestions.isNotEmpty) {
      return;
    }

    await _searchAutocomplete(query);
  }
  // CLEAR SEARCH
  void clearSearch() {
    _searchDebounce?.cancel();

    searchController.clear();

    suggestions.clear();

    isSearching.value = false;

    sessionToken =
        _generateSessionToken();
  }
  // DONE
Future<void> done() async {
  final LatLng? location = selectedLocation.value;

  if (location == null) {
    AppSnackbar.show(
      title: 'Location Required',
      message:
          'Please select your business location on the map.',
      position: SnackPosition.TOP,
    );

    return;
  }

  if (isSaving.value) {
    return;
  }

  isSaving.value = true;

  try {
    // ========================================================
    // GET FACILITY ID
    // ========================================================

    final facilityId =
        await PrefHelper.getOwnerFacilityId();

    if (facilityId == null || facilityId <= 0) {
      AppSnackbar.show(
        title: 'Error',
        message:
            'Facility information was not found.',
        position: SnackPosition.TOP,
      );

      return;
    }

    // ========================================================
    // SUBMIT LOCATION TO LARAVEL
    // ========================================================

    debugPrint('');
    debugPrint(
      '════════ OWNER SUBMIT LOCATION START ════════',
    );

    debugPrint(
      '📤 Request Data:',
    );

    debugPrint(
      '{'
      'facility_id: $facilityId, '
      'latitude: ${location.latitude}, '
      'longitude: ${location.longitude}, '
      'address: ${selectedAddress.value.trim()}'
      '}',
    );

    final result =
        await _repo.submitLocation(
      facilityId: facilityId,
      latitude: location.latitude,
      longitude: location.longitude,
      address: selectedAddress.value.trim(),
    );

    debugPrint('');
    debugPrint(
      '📥 Owner Location Response:',
    );

   

    debugPrint(
      '════════ OWNER LOCATION SUCCESS ════════',
    );

    // ========================================================
    // MARK OWNER PROFILE AS COMPLETE
    // ========================================================

    await PrefHelper.setOwnerProfileCompleted(
      true,
    );

    await PrefHelper.saveOwnerProfileCompletion(
      100,
    );

    await PrefHelper.saveOwnerOnboardingStep(
      4,
    );

    debugPrint('');

    debugPrint(
      '════════ OWNER PROFILE COMPLETED ════════',
    );

    debugPrint(
      '✅ Location saved to Laravel',
    );

    debugPrint(
      '✅ Owner profile completed: 100%',
    );

    debugPrint(
      '✅ Owner onboarding step: 4',
    );

    debugPrint(
      '🚀 Navigating to owner profile...',
    );

    // ========================================================
    // SUCCESS MESSAGE
    // ========================================================

    AppSnackbar.show(
      title: 'Profile Complete',
      message:
          'Your profile has been completed successfully.',
      position: SnackPosition.TOP,
    );

    // ========================================================
    // NAVIGATE TO OWNER PROFILE
    // ========================================================

    await Get.offNamed(
      AppRoutes.ownerRoot,
    );

    debugPrint(
      '✅ Owner profile navigation executed',
    );
  } catch (e, stackTrace) {
    debugPrint(
      '❌ Save location error: $e',
    );

    debugPrint(
      '$stackTrace',
    );

    AppSnackbar.show(
      title: 'Error',
      message: e.toString(),
      position: SnackPosition.TOP,
    );
  } finally {
    isSaving.value = false;
  }
}
  // CLOSE
  @override
  void onClose() {
    debugPrint(
      '🗺️ ClientLocationController disposing...',
    );
    _searchDebounce?.cancel();
    searchController.dispose();
    // IMPORTANT:
    // Do not use the controller after this point.
    _mapController = null;

    _dio.close();

    super.onClose();
  }
}

// ================================================================
// PLACE PREDICTION MODEL
// ================================================================

class PlacePrediction {
  final String placeId;
  final String placeResourceName;
  final String description;
  final String mainText;
  final String secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.placeResourceName,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
}
