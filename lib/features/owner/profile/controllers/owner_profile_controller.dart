import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/owner/profile/models/owner_profile_image_model.dart';
import 'package:smartware/features/owner/profile/models/owner_onboarding_repo.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class OwnerProfileController extends GetxController {
  // =========================================================
  // PROFILE DATA
  // =========================================================

  final userName = 'User name'.obs;

  final profileImage = Rx<File?>(null);

  final profileImagePath = ''.obs;

  final profileImageResponse =
      Rxn<OwnerProfileImageModel>();

  // =========================================================
  // STATES
  // =========================================================

  final isLoading = false.obs;

  final isUploadingImage = false.obs;

  final isRemovingImage = false.obs;

  // =========================================================
  // REPOSITORIES
  // =========================================================

  final OwnerOnboardingRepo _onboardingRepo =
      OwnerOnboardingRepo();

  final AuthRepo _authRepo = AuthRepo();

  // =========================================================
  // IMAGE PICKER
  // =========================================================

  final ImagePicker _picker = ImagePicker();

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    loadUserName();
    loadUserPhoto();
  }

  // =========================================================
  // USER NAME
  // =========================================================

  Future<void> loadUserName() async {
    final name = await PrefHelper.getUserName();

    if (name != null && name.isNotEmpty) {
      userName.value = name;
    }
  }

  // =========================================================
  // USER PHOTO
  // =========================================================

  Future<void> loadUserPhoto() async {
    final photoPath = await PrefHelper.getUserPhoto();

    if (photoPath != null && photoPath.isNotEmpty) {
      profileImage.value = File(photoPath);
    }
  }

  // =========================================================
  // PICK + UPLOAD PROFILE IMAGE
  // =========================================================

  Future<void> pickProfileImage() async {
    if (isUploadingImage.value) {
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        return;
      }

      final extension =
          pickedFile.path.split('.').last.toLowerCase();

      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        AppSnackbar.show(
          title: 'Invalid Image',
          message: 'Only JPG and PNG images are allowed.',
          icon: Icons.image_not_supported_outlined,
        );
        return;
      }

      final file = File(pickedFile.path);

      isUploadingImage.value = true;

      // =======================================================
      // BACKEND UPLOAD
      // =======================================================

      final result =
          await _onboardingRepo.addOrUpdatePersonalImage(
        imagePath: file.path,
      );

      // =======================================================
      // SAVE BACKEND RESPONSE
      // =======================================================

      profileImageResponse.value = result;

      profileImagePath.value = result.path;

      // =======================================================
      // UPDATE UI
      // =======================================================

      profileImage.value = file;

      // Save local path for displaying after refresh.
      await PrefHelper.saveUserPhoto(
        file.path,
      );

      AppSnackbar.show(
        title: 'Success',
        message: result.message,
        icon: Icons.check_circle_outline,
        position: SnackPosition.TOP
      );
    } catch (e) {
      Get.log(
        'Profile Image Upload Error: $e',
      );

      AppSnackbar.show(
        title: 'Error',
        message: e.toString(),
        icon: Icons.error_outline,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  // =========================================================
  // REMOVE PROFILE IMAGE + BACKEND
  // =========================================================

  Future<void> removeProfileImage() async {
    if (isRemovingImage.value) {
      return;
    }

    try {
      isRemovingImage.value = true;

      // =======================================================
      // BACKEND REMOVE
      // =======================================================

      final result =
          await _onboardingRepo.removePersonalImage();

      // =======================================================
      // CLEAR LOCAL STATE
      // =======================================================

      profileImage.value = null;

      profileImagePath.value = '';

      profileImageResponse.value = null;

      await PrefHelper.deleteUserPhoto();

      AppSnackbar.show(
        title: 'Success',
        message: result.message,
        icon: Icons.delete_outline,
        position:SnackPosition.TOP 
      );
    } catch (e) {
      Get.log(
        'Profile Image Remove Error: $e',
      );

      AppSnackbar.show(
        title: 'Error',
        message: e.toString(),
        icon: Icons.error_outline,
      );
    } finally {
      isRemovingImage.value = false;
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    try {
      await _authRepo.logout();

      await PrefHelper.clearUser();

      Get.offAllNamed(
        AppRoutes.onboarding,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Error',
        message: e.toString(),
        icon: Icons.error_outline,
      );
    }
  }
}