import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerWorkersController extends GetxController {
  // ===========================================================================
  // SEARCH
  // ===========================================================================

  final TextEditingController searchController =
      TextEditingController();

  final RxString searchQuery = ''.obs;

  // ===========================================================================
  // WORKERS
  // ===========================================================================

  final RxList<WorkerModel> workers = <WorkerModel>[
    WorkerModel(
      id: '1',
      firstName: 'Ahmad',
      lastName: 'Hassan',
      nationalId: '0102030405',
    ),
    WorkerModel(
      id: '2',
      firstName: 'Omar',
      lastName: 'Khaled',
      nationalId: '0203040506',
    ),
  ].obs;

  // ===========================================================================
  // FILTERED WORKERS
  // ===========================================================================

  List<WorkerModel> get filteredWorkers {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return workers.toList();
    }

    return workers.where((worker) {
      return worker.firstName.toLowerCase().contains(query) ||
          worker.lastName.toLowerCase().contains(query) ||
          worker.fullName.toLowerCase().contains(query) ||
          worker.nationalId.toLowerCase().contains(query);
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
  // ADD WORKER
  // ===========================================================================

  void addWorker({
    required String firstName,
    required String lastName,
    required String nationalId,
  }) {
    final worker = WorkerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      nationalId: nationalId.trim(),
    );

    workers.add(worker);
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
// WORKER MODEL
// =============================================================================

class WorkerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String nationalId;

  const WorkerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
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