import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storex/core/utils/pref_helper.dart';

class ClientProfileController extends GetxController {
  /// =========================================================
  /// PROFILE DATA
  /// =========================================================

  final businessName = "StoreX Business".obs;

  final profileImage = Rx<File?>(null);

  /// =========================================================
  /// STATES
  /// =========================================================

  final isLoading = false.obs;

  final isUploadingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserPhoto();
  }

  Future<void> loadUserPhoto() async {
    final photoPath = await PrefHelper.getUserPhoto();

    if (photoPath != null && photoPath.isNotEmpty) {
      profileImage.value = File(photoPath);
    }
  }

  /// =========================================================
  /// IMAGE PICKER
  /// =========================================================

  final ImagePicker _picker = ImagePicker();

  Future<void> pickProfileImage() async {
    try {
      isUploadingImage.value = true;

      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);

      profileImage.value = file;

      await PrefHelper.saveUserPhoto(pickedFile.path);
    } catch (e) {
      Get.log("Profile Image Error: $e");
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> removeProfileImage() async {
    profileImage.value = null;
    await PrefHelper.deleteUserPhoto();
  }

  /// =========================================================
  /// LOGOUT
  /// =========================================================

  Future<void> logout() async {
    try {
      isLoading.value = true;

      /// TODO:
      /// API Logout

      // await authRepository.logout();
    } finally {
      isLoading.value = false;
    }
  }
}