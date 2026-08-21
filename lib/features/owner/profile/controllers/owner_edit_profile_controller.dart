import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';

import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_complition_controller.dart';
import 'package:smartware/features/owner/profile/models/owner_onboarding_repo.dart';

import 'package:smartware/features/owner/profile/widgets/owner_change_facility_name.dart';
import 'package:smartware/features/owner/profile/widgets/owner_change_email.dart';
import 'package:smartware/features/owner/profile/widgets/owner_change_password.dart';
import 'package:smartware/features/owner/profile/widgets/owner_change_phone.dart';
import 'package:smartware/features/owner/profile/widgets/owner_change_preferences.dart';
import 'package:smartware/features/owner/profile/widgets/owner_verify_new_email.dart';

import 'package:smartware/widgets/app_snackbar.dart';

class OwnerEditProfileController extends GetxController {
  // ============================================================
  // OWNER ROLE
  // ============================================================

  // IMPORTANT:
  // Do NOT get this from PrefHelper.
  // PrefHelper may contain "warehouseAdmin",
  // but the backend expects "warehouse_admin".
  static const String ownerRole = 'warehouse_admin';

  // ============================================================
  // REPOSITORIES
  // ============================================================

  final AuthRepo _authRepo = AuthRepo();
  final OwnerOnboardingRepo _ownerOnboardingRepo = OwnerOnboardingRepo();

  // ============================================================
  // PROFILE DATA
  // ============================================================

  final RxString businessName = ''.obs;
  final RxString selectedBusinessName = ''.obs;
  final RxString email = ''.obs;
  final RxString pendingEmail = ''.obs;
  final RxString phone = ''.obs;

  // ============================================================
  // OWNER PREFERENCES
  // ============================================================

  final RxString editBusinessType = ''.obs;

  final RxList<String> editBusinessCategories = <String>[].obs;

  final RxBool hasPreferences = false.obs;

  final RxBool isPreferencesLoading = false.obs;

  // ============================================================
  // GENERAL LOADING
  // ============================================================

  final RxBool isLoading = false.obs;

  // ============================================================
  // FORM KEYS
  // ============================================================

  final changeEmailFormKey = GlobalKey<FormState>();

  final personalInfoFormKey = GlobalKey<FormState>();

  final contactSecurityFormKey = GlobalKey<FormState>();

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  late final TextEditingController businessNameController;

  late final TextEditingController emailController;

  late final TextEditingController newEmailController;

  late final TextEditingController phoneController;

  final passwordController = TextEditingController();

  final verificationCodeController = TextEditingController();

  // ============================================================
  // EMAIL VERIFICATION
  // ============================================================

  Timer? timer;

  final RxInt secondsRemaining = 60.obs;

  final RxBool isResendEnabled = false.obs;

  // ============================================================
  // PASSWORD
  // ============================================================

  final RxBool obscurePassword = true.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    businessNameController = TextEditingController();

    emailController = TextEditingController();

    newEmailController = TextEditingController();

    phoneController = TextEditingController();

    _loadSavedProfileData();
  }

  // ============================================================
  // COMPLETION CONTROLLER
  // ============================================================

  OwnerProfileComplitionController get _completionController {
    if (Get.isRegistered<OwnerProfileComplitionController>()) {
      return Get.find<OwnerProfileComplitionController>();
    }

    return Get.put(OwnerProfileComplitionController());
  }

  // ============================================================
  // LOAD PROFILE DATA
  // ============================================================

  Future<void> _loadSavedProfileData() async {
    try {
      debugPrint('');
      debugPrint('════════ LOAD OWNER PROFILE DATA ════════');

      // --------------------------------------------------------
      // BUSINESS NAME
      // --------------------------------------------------------

      final savedBusinessName = await PrefHelper.getOwnerBusinessName();

      if (savedBusinessName.trim().isNotEmpty) {
        businessName.value = savedBusinessName.trim();

        selectedBusinessName.value = savedBusinessName.trim();

        businessNameController.text = savedBusinessName.trim();
      }

      // --------------------------------------------------------
      // EMAIL
      // --------------------------------------------------------

      final savedEmail = await PrefHelper.getUserEmail();

     if (savedEmail.trim().isNotEmpty) {
        email.value = savedEmail.trim();

        emailController.text = savedEmail.trim();
      }

      // --------------------------------------------------------
      // PHONE
      // --------------------------------------------------------

      final savedPhone = await PrefHelper.getUserPhone();

      if (savedPhone != null && savedPhone.trim().isNotEmpty) {
        phone.value = savedPhone.trim();

        phoneController.text = savedPhone.trim();
      }

      // --------------------------------------------------------
      // OWNER PREFERENCES
      // --------------------------------------------------------

      await loadEditPreferences();

      debugPrint('');
      debugPrint('✅ OWNER PROFILE DATA LOADED');

      debugPrint('🏢 Business Name: ${businessName.value}');

      debugPrint('📧 Email: ${email.value}');

      debugPrint('📱 Phone: ${phone.value}');

      debugPrint('🏪 Business Type: ${editBusinessType.value}');

      debugPrint(
        '📦 Categories: '
        '${editBusinessCategories.toList()}',
      );

      debugPrint('👤 API Owner Role: $ownerRole');

      debugPrint('══════════════════════════════════════');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to load owner profile data: $e');

      debugPrint('$stackTrace');
    }
  }

  // ============================================================
  // LOAD OWNER PREFERENCES
  // ============================================================

  Future<void> loadEditPreferences() async {
    if (isPreferencesLoading.value) {
      return;
    }

    isPreferencesLoading.value = true;

    try {
      debugPrint('');
      debugPrint('════════ LOAD OWNER EDIT PREFERENCES ════════');

      final businessType = await PrefHelper.getOwnerBusinessType();

      final categories = await PrefHelper.getOwnerSelectedProducts();

      debugPrint('💾 OWNER BUSINESS TYPE: $businessType');

      debugPrint('💾 OWNER CATEGORIES: $categories');

      // --------------------------------------------------------
      // NO DATA
      // --------------------------------------------------------

      if (businessType.trim().isEmpty || categories.isEmpty) {
        hasPreferences.value = false;

        editBusinessType.value = '';

        editBusinessCategories.clear();

        debugPrint('❌ No saved OWNER preferences found.');

        return;
      }

      // --------------------------------------------------------
      // LOAD DATA
      // --------------------------------------------------------

      hasPreferences.value = true;

      editBusinessType.value = businessType.trim();

      editBusinessCategories.assignAll(
        categories
            .map((category) => category.trim())
            .where((category) => category.isNotEmpty)
            .toList(),
      );

      // --------------------------------------------------------
      // SYNC COMPLETION CONTROLLER
      // --------------------------------------------------------

      final completion = _completionController;

      completion.selectedProducts.assignAll(editBusinessCategories);

      debugPrint('');
      debugPrint('✅ OWNER PREFERENCES LOADED');

      debugPrint(
        '🏪 Business Type: '
        '${editBusinessType.value}',
      );

      debugPrint(
        '📦 Categories: '
        '${editBusinessCategories.toList()}',
      );

      debugPrint('════════════════════════════════════════');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to load owner preferences: $e');

      debugPrint('$stackTrace');

      hasPreferences.value = false;

      editBusinessType.value = '';

      editBusinessCategories.clear();

      AppSnackbar.show(
        title: 'Error'.tr,
        message: 'Unable to load your business preferences.'.tr,
        icon: Icons.error_outline,
      );
    } finally {
      isPreferencesLoading.value = false;
    }
  }

  // ============================================================
  // SET BUSINESS TYPE
  // ============================================================

  void setEditBusinessType(String value) {
    final newValue = value.trim();

    debugPrint('');
    debugPrint('🔄 OWNER BUSINESS TYPE CHANGED');

    debugPrint('Old: ${editBusinessType.value}');

    debugPrint('New: $newValue');

    editBusinessType.value = newValue;
  }

  // ============================================================
  // SET CATEGORIES
  // ============================================================

  void setEditBusinessCategories(List<String> categories) {
    final cleanedCategories = categories
        .map((category) => category.trim())
        .where((category) => category.isNotEmpty)
        .toList();

    debugPrint('');
    debugPrint('🔄 OWNER CATEGORIES CHANGED');

    debugPrint('Old: ${editBusinessCategories.toList()}');

    debugPrint('New: $cleanedCategories');

    editBusinessCategories.assignAll(cleanedCategories);

    // ----------------------------------------------------------
    // SYNC COMPLETION CONTROLLER
    // ----------------------------------------------------------

    final completion = _completionController;

    completion.selectedProducts.assignAll(cleanedCategories);

    debugPrint('✅ Owner categories synchronized.');
  }

  // ============================================================
  // UPDATE OWNER PREFERENCES
  // ============================================================

  Future<void> updateBusinessPreferences() async {
    if (isPreferencesLoading.value) {
      return;
    }

    if (isLoading.value) {
      debugPrint('⚠️ Preferences update already running.');

      return;
    }

    final completion = _completionController;

    // ----------------------------------------------------------
    // GET CURRENT CATEGORIES
    // ----------------------------------------------------------

    final categories = completion.selectedProducts
        .map((category) => category.trim())
        .where((category) => category.isNotEmpty)
        .toList();

    debugPrint('');
    debugPrint('════════ UPDATE OWNER PREFERENCES ════════');

    debugPrint('📦 Categories: $categories');

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (categories.isEmpty) {
      AppSnackbar.show(
        title: 'Incomplete Preferences'.tr,
        message: 'Please select at least one product category.'.tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    isLoading.value = true;

    try {
      // ========================================================
      // FACILITY NAME
      // ========================================================

      final facilityName = await PrefHelper.getOwnerBusinessName();

      if (facilityName.trim().isEmpty) {
        AppSnackbar.show(
          title: 'Error'.tr,
          message: 'Business facility information was not found.'.tr,
          icon: Icons.error_outline,
        );

        return;
      }

      // ========================================================
      // ROLE
      // ========================================================
      //
      // DO NOT READ PrefHelper.getUserRole()
      //
      // That value currently contains:
      //
      // warehouseAdmin
      //
      // The API expects:
      //
      // warehouse_admin
      //
      // ========================================================

      const role = ownerRole;

      debugPrint('');
      debugPrint('📤 DATA SENT TO API');

      debugPrint('🏢 Facility Name: $facilityName');

      debugPrint('👤 Role: $role');

      debugPrint('📦 Categories: $categories');

      // ========================================================
      // API REQUEST
      // ========================================================

      final result = await _ownerOnboardingRepo.savePreferences(
        facilityName: facilityName,
        role: role,
        categories: categories,
      );

      // ========================================================
      // SERVER RESPONSE
      // ========================================================

      debugPrint('');
      debugPrint('════════ OWNER PREFERENCES RESPONSE ════════');

      debugPrint('💬 Message: ${result.message}');

      debugPrint('🏢 Facility ID: ${result.facility.id}');

      debugPrint('🏢 Facility Name: ${result.facilityName}');

      debugPrint(
        '🏪 Business Type: '
        '${result.facility.businessType}',
      );

      final returnedCategories = result.facility.categories
          .map((category) => category.name.trim())
          .where((category) => category.isNotEmpty)
          .toList();

      debugPrint('📦 Categories: $returnedCategories');

      // ========================================================
      // SAVE SERVER VALUES
      // ========================================================

      final finalBusinessType = result.facility.businessType.trim();

      final finalCategories = returnedCategories;

      await PrefHelper.saveOwnerBusinessType(finalBusinessType);

      await PrefHelper.saveOwnerSelectedProducts(finalCategories);

      await PrefHelper.saveOwnerBusinessCategories(finalCategories);

      await PrefHelper.saveOwnerFacilityId(result.facility.id);

      // ========================================================
      // UPDATE LOCAL STATE
      // ========================================================

      editBusinessType.value = finalBusinessType;

      editBusinessCategories.assignAll(finalCategories);

      completion.selectedProducts.assignAll(finalCategories);

      hasPreferences.value = true;

      debugPrint('');
      debugPrint('💾 OWNER LOCAL STORAGE UPDATED');

      debugPrint(
        '🏪 Business Type: '
        '$finalBusinessType',
      );

      debugPrint(
        '📦 Categories: '
        '$finalCategories',
      );

      debugPrint('👤 Role used: $role');

      // ========================================================
      // SUCCESS
      // ========================================================

      Get.back();

      AppSnackbar.show(
        title: 'Preferences Updated'.tr,
        message: result.message.tr,
        icon: Icons.check_circle_outline,
      );

      debugPrint('✅ OWNER PREFERENCES UPDATE SUCCESS');
    } catch (e, stackTrace) {
      debugPrint('');
      debugPrint('════════ OWNER PREFERENCES UPDATE ERROR ════════');

      debugPrint('❌ Error: $e');

      debugPrint('❌ Type: ${e.runtimeType}');

      debugPrint('❌ StackTrace: $stackTrace');

      AppSnackbar.show(
        title: 'Update Failed'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // FRIENDLY ERROR
  // ============================================================

  String _getFriendlyErrorMessage(dynamic error) {
    String message;

    if (error is ApiError) {
      message = error.message;
    } else {
      message = error.toString().replaceAll('Exception: ', '');
    }

    if (message.contains('email_already_exists') || message.contains('taken')) {
      return 'This email address is already registered to another account.'.tr;
    }

    if (message.contains('phone_already_exists') ||
        message.contains('phone_number_taken')) {
      return 'This phone number is already registered to another account.'.tr;
    }

    return message.tr;
  }

  // ============================================================
  // SAVE PREFERENCES
  // ============================================================

  Future<void> savePreferences() async {
    await updateBusinessPreferences();
  }

  // ============================================================
  // EMAIL RESEND TIMER
  // ============================================================

  void startResendTimer() {
    isResendEnabled.value = false;

    secondsRemaining.value = 60;

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        isResendEnabled.value = true;

        timer.cancel();
      }
    });
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void goToEmail() {
    newEmailController.clear();

    Get.to(() => OwnerChangeEmail());
  }

  void goToPhone() {
    Get.to(() => OwnerChangePhone());
  }

  void goToPassword() {
    Get.to(() => OwnerChangePassword());
  }

  void goToPreferences() {
    Get.to(() => const OwnerChangePreferences());
  }

  void goToBusiness() {
    Get.to(() => OwnerChangeFacilityName());
  }

  void goToEmailVerification() {
    Get.to(() => const OwnerVerifyNewEmail());

    startResendTimer();
  }

  // ============================================================
  // CHANGE PHONE NUMBER
  // ============================================================

  Future<void> changePhoneNumber() async {
    final newPhone = phoneController.text.trim();

    if (newPhone.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter your phone number'.tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    final phoneRegex = RegExp(r'^09\d{8}$');

    if (!phoneRegex.hasMatch(newPhone)) {
      AppSnackbar.show(
        title: 'Invalid Phone Number'.tr,
        message:
            'Please enter a valid phone number starting with 09 and containing 10 digits'
                .tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    if (newPhone == phone.value) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message: 'Please enter a different phone number'.tr,
        icon: Icons.info_outline,
      );

      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final result = await _ownerOnboardingRepo.changePhoneNumber(
        phoneNumber: newPhone,
      );

      phone.value = result.phoneNumber;

      phoneController.text = result.phoneNumber;

      await PrefHelper.saveUserPhone(result.phoneNumber);

      Get.back();

      AppSnackbar.show(
        title: 'Phone Number Updated'.tr,
        message: result.message.tr,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Phone Number Update Failed'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SEND EMAIL CHANGE REQUEST
  // ============================================================

  Future<void> sendEmailChangeRequest() async {
    if (changeEmailFormKey.currentState?.validate() != true) {
      return;
    }

    final targetEmail = newEmailController.text.trim();

    if (targetEmail == email.value) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message: 'Please enter a different email address'.tr,
        icon: Icons.info_outline,
      );

      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      await _authRepo.requestClientEmailChange(email: targetEmail);

      pendingEmail.value = targetEmail;

      goToEmailVerification();

      AppSnackbar.show(
        title: 'Verification Link Sent'.tr,
        message: 'We sent a verification link to your new email address.'.tr,
        icon: Icons.mark_email_read_outlined,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Email Request Failed'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // VERIFY NEW EMAIL
  // ============================================================

  Future<void> verifyNewEmail() async {
    if (pendingEmail.value.trim().isEmpty) {
      return;
    }

    isLoading.value = true;

    try {
      email.value = pendingEmail.value;

      emailController.text = pendingEmail.value;

      await PrefHelper.saveUserEmail(pendingEmail.value);

      pendingEmail.value = '';

      timer?.cancel();

      Get.back();
      Get.back();

      AppSnackbar.show(
        title: 'Email Updated'.tr,
        message: 'Your email address was updated successfully'.tr,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Error'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // RESEND EMAIL
  // ============================================================

  Future<void> resendEmailCode() async {
    if (!isResendEnabled.value) {
      return;
    }

    if (pendingEmail.value.trim().isEmpty) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      await _authRepo.requestClientEmailChange(email: pendingEmail.value);

      startResendTimer();

      AppSnackbar.show(
        title: 'Email Sent'.tr,
        message: 'A new verification link has been sent to your email'.tr,
        icon: Icons.email_outlined,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Resend Failed'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SAVE PERSONAL INFO
  // ============================================================

  Future<void> savePersonalInfo() async {
    if (personalInfoFormKey.currentState?.validate() != true) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      businessName.value = businessNameController.text.trim();

      selectedBusinessName.value = businessName.value;

      await PrefHelper.saveOwnerBusinessName(businessName.value);

      Get.back();

      AppSnackbar.show(
        title: 'Success'.tr,
        message: 'Personal info updated'.tr,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Error'.tr,
        message: 'Something went wrong. Please try again'.tr,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SAVE CONTACT & SECURITY
  // ============================================================

  Future<void> saveContactSecurity() async {
    if (contactSecurityFormKey.currentState?.validate() != true) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      email.value = emailController.text.trim();

      phone.value = phoneController.text.trim();

      await PrefHelper.saveUserEmail(email.value);

      await PrefHelper.saveUserPhone(phone.value);

      passwordController.clear();

      Get.back();

      AppSnackbar.show(
        title: 'Success'.tr,
        message: 'Contact & security updated'.tr,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Error'.tr,
        message: 'Something went wrong. Please try again'.tr,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // PASSWORD VISIBILITY
  // ============================================================

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // ============================================================
// CHANGE PASSWORD
// ============================================================

Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  if (isLoading.value) {
    return;
  }

  if (currentPassword.isEmpty) {
    AppSnackbar.show(
      title: 'Required'.tr,
      message: 'Please enter your current password'.tr,
      icon: Icons.warning_amber_rounded,
    );

    return;
  }

  if (newPassword.isEmpty) {
    AppSnackbar.show(
      title: 'Required'.tr,
      message: 'Please enter your new password'.tr,
      icon: Icons.warning_amber_rounded,
    );

    return;
  }

  if (newPassword.length < 8) {
    AppSnackbar.show(
      title: 'Weak Password'.tr,
      message:
          'Your new password must be at least 8 characters'.tr,
      icon: Icons.lock_outline,
    );

    return;
  }

  if (currentPassword == newPassword) {
    AppSnackbar.show(
      title: 'No Changes'.tr,
      message:
          'Your new password must be different from your current password'
              .tr,
      icon: Icons.info_outline,
    );

    return;
  }

  isLoading.value = true;

  try {
    await _ownerOnboardingRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    Get.back();

    AppSnackbar.show(
      title: 'Password Updated'.tr,
      message:
          'Your password has been changed successfully'.tr,
      icon: Icons.check_circle_outline,
    );
  } catch (e) {
    AppSnackbar.show(
      title: 'Password Update Failed'.tr,
      message: _getFriendlyErrorMessage(e),
      icon: Icons.error_outline,
    );
  } finally {
    isLoading.value = false;
  }
}

  // ============================================================
  // UPDATE BUSINESS NAME
  // ============================================================

  Future<void> updateBusinessName() async {
    final newName = businessName.value.trim();

    debugPrint('');
    debugPrint('════════ UPDATE OWNER BUSINESS NAME ════════');

    debugPrint('🏢 New Business Name: $newName');

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (newName.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter a business name'.tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    if (newName.length < 2) {
      AppSnackbar.show(
        title: 'Invalid Business Name'.tr,
        message: 'Business name must contain at least 2 characters'.tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    if (newName == selectedBusinessName.value.trim()) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message: 'Please enter a different business name'.tr,
        icon: Icons.info_outline,
      );

      return;
    }

    // ----------------------------------------------------------
    // FACILITY ID
    // ----------------------------------------------------------

    final facilityId = await PrefHelper.getOwnerFacilityId();

    if (facilityId == null || facilityId <= 0) {
      AppSnackbar.show(
        title: 'Error'.tr,
        message: 'Unable to find your business facility.'.tr,
        icon: Icons.error_outline,
      );

      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      debugPrint('🏢 Facility ID: $facilityId');

      debugPrint('📤 New Name: $newName');

      final result = await _ownerOnboardingRepo.updateBusinessName(
        businessName: newName,
        facilityId: facilityId,
      );

      debugPrint('');
      debugPrint('════════ BUSINESS NAME RESPONSE ════════');

      debugPrint('💬 Message: ${result.message}');

      debugPrint('🏢 Facility ID: ${result.facility.id}');

      debugPrint(
        '🏢 Business Name EN: '
        '${result.facility.facilityNameEn}',
      );

      debugPrint(
        '🏢 Business Name AR: '
        '${result.facility.facilityNameAr}',
      );

      final returnedName = result.facility.facilityNameEn?.trim();

      final finalBusinessName = returnedName != null && returnedName.isNotEmpty
          ? returnedName
          : newName;

      // --------------------------------------------------------
      // UPDATE CONTROLLER
      // --------------------------------------------------------

      businessName.value = finalBusinessName;

      selectedBusinessName.value = finalBusinessName;

      businessNameController.text = finalBusinessName;

      // --------------------------------------------------------
      // SAVE OWNER BUSINESS NAME
      // --------------------------------------------------------

      await PrefHelper.saveOwnerBusinessName(finalBusinessName);

      debugPrint('');
      debugPrint('💾 OWNER BUSINESS NAME UPDATED LOCALLY');

      debugPrint(
        '🏢 Business Name: '
        '$finalBusinessName',
      );

      // --------------------------------------------------------
      // CLOSE
      // --------------------------------------------------------

      Get.back();

      AppSnackbar.show(
        title: 'Business Name Updated'.tr,
        message: result.message.tr,
        icon: Icons.check_circle_outline,
      );

      debugPrint('✅ OWNER BUSINESS NAME UPDATE SUCCESS');
    } catch (e, stackTrace) {
      debugPrint('');
      debugPrint('════════ BUSINESS NAME UPDATE ERROR ════════');

      debugPrint('❌ Error: $e');

      debugPrint('❌ Type: ${e.runtimeType}');

      debugPrint('❌ StackTrace: $stackTrace');

      AppSnackbar.show(
        title: 'Business Name Update Failed'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    businessNameController.dispose();

    emailController.dispose();

    newEmailController.dispose();

    phoneController.dispose();

    passwordController.dispose();

    verificationCodeController.dispose();

    timer?.cancel();

    super.onClose();
  }
}
