import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';

import 'package:smartware/features/owner/profile/models/owner_workers_repo.dart';


class OwnerWorkersController extends GetxController {
  // ===========================================================================
  // REPOSITORY
  // ===========================================================================

  final OwnerWorkersRepo _repo = OwnerWorkersRepo();

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  final TextEditingController searchController =
      TextEditingController();

  final RxString searchQuery = ''.obs;

  // ===========================================================================
  // LOADING
  // ===========================================================================

  final RxBool isLoading = false.obs;

  // ===========================================================================
  // WORKERS
  // ===========================================================================

  final RxList<WorkerModel> workers =
      <WorkerModel>[].obs;

  // ===========================================================================
  // FILTERED WORKERS
  // ===========================================================================

  List<WorkerModel> get filteredWorkers {
    final query =
        searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return workers.toList();
    }

    return workers.where((worker) {
      return worker.firstName
              .toLowerCase()
              .contains(query) ||
          worker.lastName
              .toLowerCase()
              .contains(query) ||
          worker.fullName
              .toLowerCase()
              .contains(query) ||
          worker.nationalId
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  // ===========================================================================
  // ADD / ANNOUNCE WORKER
  // ===========================================================================

  Future<bool> addWorker({
    required String firstName,
    required String lastName,
    required String nationalId,
  }) async {
    if (isLoading.value) {
      return false;
    }

    final cleanFirstName = firstName.trim();
    final cleanLastName = lastName.trim();
    final cleanNationalId = nationalId.trim();

    // =========================================================================
    // VALIDATION
    // =========================================================================

    if (cleanFirstName.isEmpty ||
        cleanLastName.isEmpty ||
        cleanNationalId.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please enter all worker information.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    // =========================================================================
    // GET FACILITY ID
    // =========================================================================

    final storedFacilityId =
        await PrefHelper.getOwnerFacilityId();

    print('');
    print('════════ GET OWNER FACILITY ID ════════');
    print('🏢 Stored Facility ID: $storedFacilityId');
    print('📦 Type: ${storedFacilityId.runtimeType}');
    print('════════════════════════════════════════');

    if (storedFacilityId == null) {
      Get.snackbar(
        'Error',
        'Warehouse information was not found.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    // IMPORTANT:
    // PrefHelper may return either int or String.
    // Do NOT cast it directly to String.

    final int? facilityId;

    if (storedFacilityId is int) {
      facilityId = storedFacilityId;
    } else {
      facilityId = int.tryParse(
        storedFacilityId.toString(),
      );
    }

    if (facilityId == null) {
      Get.snackbar(
        'Error',
        'Invalid warehouse ID.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    // =========================================================================
    // API
    // =========================================================================

    try {
      isLoading.value = true;

      print('');
      print('════════ ANNOUNCE WORKER START ════════');

      print('👤 First Name: $cleanFirstName');
      print('👤 Last Name: $cleanLastName');
      print('🪪 National ID: $cleanNationalId');
      print('🏢 Facility ID: $facilityId');

      final response =
          await _repo.announceWorker(
        firstName: cleanFirstName,
        lastName: cleanLastName,
        nationalId: cleanNationalId,
        facilityId: facilityId,
      );

      print('');
      print('════════ ANNOUNCE WORKER SUCCESS ════════');
      print('💬 Message: ${response.message}');
      print('🆔 Worker ID: ${response.data.id}');
      print(
        '🏢 Employment Warehouse ID: '
        '${response.data.employmentWarehouseId}',
      );
      print('👤 Name: ${response.data.firstName} ${response.data.lastName}');
      print('🪪 National ID: ${response.data.nationalId}');
      print('📌 Claimed: ${response.data.claimed}');
      print('════════════════════════════════════════');

      // =========================================================================
      // ADD RESPONSE TO UI
      // =========================================================================

      workers.add(
        WorkerModel(
          id: response.data.id.toString(),
          firstName: response.data.firstName,
          lastName: response.data.lastName,
          nationalId: response.data.nationalId,
          employmentWarehouseId:
              response.data.employmentWarehouseId.toString(),
          claimed: response.data.claimed,
        ),
      );

      Get.snackbar(
        'Worker Added',
        response.message.isNotEmpty
            ? response.message
            : 'Worker added successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on ApiError catch (e) {
      print('');
      print('════════ ANNOUNCE WORKER API ERROR ════════');
      print('❌ ${e.message}');
      print('════════════════════════════════════════');

      Get.snackbar(
        'Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } catch (e, stackTrace) {
      print('');
      print('════════ ANNOUNCE WORKER UNKNOWN ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace:');
      print(stackTrace);
      print('════════════════════════════════════════');

      Get.snackbar(
        'Error',
        'Something went wrong while adding the worker.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================================
  // REMOVE WORKER
  // ===========================================================================

  void removeWorker(WorkerModel worker) {
    workers.removeWhere(
      (item) => item.id == worker.id,
    );
  }

  // ===========================================================================
  // CLEAN UP
  // ===========================================================================

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

// =============================================================================
// UI WORKER MODEL
// =============================================================================

class WorkerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String nationalId;
  final String employmentWarehouseId;
  final bool claimed;

  const WorkerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    required this.employmentWarehouseId,
    required this.claimed,
  });

  // ===========================================================================
  // FULL NAME
  // ===========================================================================

  String get fullName {
    return '$firstName $lastName';
  }

  // ===========================================================================
  // INITIALS
  // ===========================================================================

  String get initials {
    final first = firstName.trim();
    final last = lastName.trim();

    if (first.isEmpty && last.isEmpty) {
      return '?';
    }

    if (first.isEmpty) {
      return last.substring(0, 1).toUpperCase();
    }

    if (last.isEmpty) {
      return first.substring(0, 1).toUpperCase();
    }

    return '${first.substring(0, 1)}'
        '${last.substring(0, 1)}'
        .toUpperCase();
  }
}