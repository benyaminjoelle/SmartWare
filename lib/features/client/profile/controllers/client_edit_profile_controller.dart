import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';

import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/client/profile/models/client_onboarding_repo.dart';

import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';

import 'package:smartware/features/client/profile/widgets/change_business_name.dart';
import 'package:smartware/features/client/profile/widgets/change_email.dart';
import 'package:smartware/features/client/profile/widgets/change_password.dart';
import 'package:smartware/features/client/profile/widgets/change_phone.dart';
import 'package:smartware/features/client/profile/widgets/change_preferences.dart';
import 'package:smartware/features/client/profile/widgets/verify_new_email.dart';

import 'package:smartware/widgets/app_snackbar.dart';

class ClientEditProfileController extends GetxController {
  // ============================================================
  // REPOSITORIES
  // ============================================================

  final AuthRepo _authRepo = AuthRepo();

  final ClientOnboardingRepo _clientOnboardingRepo =
      ClientOnboardingRepo();

  // ============================================================
  // PROFILE DATA
  // ============================================================

  final RxString businessName = ''.obs;
  final RxString selectedBusinessName = ''.obs;
  final RxString email = ''.obs;
  final RxString pendingEmail = ''.obs;
  final RxString phone = ''.obs;

  // ============================================================
  // PREFERENCES
  // ============================================================

  final RxString editBusinessType = ''.obs;

  final RxList<String> editBusinessCategories =
      <String>[].obs;

  final RxBool hasPreferences = false.obs;

  final RxBool isPreferencesLoading = false.obs;

  // ============================================================
  // LOADING
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
  // TEST BUSINESSES
  // ============================================================

  final List<String> businesses = [
    'Bella Restaurant',
    'Fresh Market',
    'Tech Store',
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    businessNameController = TextEditingController(
      text: businessName.value,
    );

    emailController = TextEditingController(
      text: email.value,
    );

    newEmailController = TextEditingController();

    phoneController = TextEditingController(
      text: phone.value,
    );
  }

  // ============================================================
  // GET COMPLETION CONTROLLER
  // ============================================================

  ClientProfileCompletionController
      get _completionController {
    return Get.find<ClientProfileCompletionController>();
  }

  // ============================================================
  // LOAD SAVED PREFERENCES
  // ============================================================

  Future<void> loadEditPreferences() async {
    if (isPreferencesLoading.value) {
      return;
    }

    isPreferencesLoading.value = true;

    try {
      print('');
      print('════════ LOAD EDIT PREFERENCES ════════');

      final businessType =
          await PrefHelper.getBusinessType();

      final categories =
          await PrefHelper.getBusinessCategories();

      print(
        '💾 LOCAL BUSINESS TYPE: $businessType',
      );

      print(
        '💾 LOCAL CATEGORIES: $categories',
      );

      if (businessType == null ||
          businessType.trim().isEmpty ||
          categories.isEmpty) {
        hasPreferences.value = false;

        editBusinessType.value = '';

        editBusinessCategories.clear();

        print('❌ No saved preferences found.');

        return;
      }

      // ----------------------------------------------------------
      // LOAD INTO EDIT CONTROLLER
      // ----------------------------------------------------------

      hasPreferences.value = true;

      editBusinessType.value =
          businessType.trim();

      editBusinessCategories.assignAll(
        categories,
      );

      // ----------------------------------------------------------
      // IMPORTANT:
      // The existing BusinessTypeSection and ProductTypeSection
      // use ClientProfileCompletionController.
      //
      // Therefore we MUST put the loaded values there too.
      // ----------------------------------------------------------

      final completion =
          _completionController;

      completion.selectedBusinessType.value =
          businessType.trim();

      completion.selectedProducts.assignAll(
        categories,
      );

      print('');
      print('✅ LOCAL PREFERENCES LOADED');

      print(
        '🏪 Business Type: '
        '${editBusinessType.value}',
      );

      print(
        '📦 Categories: '
        '${editBusinessCategories.toList()}',
      );

      print('');
      print('🔗 COMPLETION CONTROLLER SYNCHRONIZED');

      print(
        '🏪 UI Business Type: '
        '${completion.selectedBusinessType.value}',
      );

      print(
        '📦 UI Categories: '
        '${completion.selectedProducts.toList()}',
      );

      print(
        '════════════════════════════════════',
      );
    } catch (e, stackTrace) {
      print('❌ Failed to load preferences: $e');
      print(stackTrace);

      hasPreferences.value = false;

      AppSnackbar.show(
        title: 'Error'.tr,
        message:
            'Unable to load your business preferences.'.tr,
        icon: Icons.error_outline,
      );
    } finally {
      isPreferencesLoading.value = false;
    }
  }

  // ============================================================
  // UPDATE LOCAL BUSINESS TYPE
  // ============================================================

  void setEditBusinessType(String value) {
    print('');
    print('🔄 BUSINESS TYPE CHANGED');

    print(
      'Old: ${editBusinessType.value}',
    );

    print(
      'New: $value',
    );

    editBusinessType.value = value.trim();

    // Keep the UI controller synchronized.
    _completionController.selectedBusinessType.value =
        value.trim();

    print(
      'Controller now contains: '
      '${editBusinessType.value}',
    );
  }

  // ============================================================
  // UPDATE LOCAL CATEGORIES
  // ============================================================

  void setEditBusinessCategories(
    List<String> categories,
  ) {
    print('');
    print('🔄 CATEGORIES CHANGED');

    print(
      'Old: ${editBusinessCategories.toList()}',
    );

    print(
      'New: $categories',
    );

    editBusinessCategories.assignAll(
      categories,
    );

    _completionController.selectedProducts
        .assignAll(categories);

    print(
      'Controller now contains: '
      '${editBusinessCategories.toList()}',
    );
  }

  // ============================================================
  // SAVE / UPDATE PREFERENCES
  // ============================================================

  Future<void> updateBusinessPreferences() async {
    if (!hasPreferences.value) {
      print(
        '❌ Cannot update: no preferences loaded.',
      );
      return;
    }

    if (isLoading.value) {
      print(
        '⚠️ Update already running.',
      );
      return;
    }

    // ============================================================
    // IMPORTANT FIX
    //
    // DO NOT READ THE OLD editBusinessCategories HERE.
    //
    // The UI sections modify ClientProfileCompletionController.
    // Therefore we read the actual current UI selection from there.
    // ============================================================

    final completion =
        _completionController;

    final businessType =
        completion.selectedBusinessType.value.trim();

    final categories = completion.selectedProducts
        .map((category) => category.trim())
        .where((category) => category.isNotEmpty)
        .toList();

    print('');
    print(
      '════════════════════════════════════════',
    );
    print(
      '🚀 UPDATE PREFERENCES START',
    );
    print(
      '════════════════════════════════════════',
    );

    print('');
    print(
      '📌 ACTUAL VALUES SELECTED IN UI',
    );

    print(
      '🏪 Business Type: $businessType',
    );

    print(
      '📦 Categories: $categories',
    );

    // ============================================================
    // VALIDATION
    // ============================================================

    if (businessType.isEmpty) {
      print(
        '❌ Business type is empty.',
      );

      AppSnackbar.show(
        title: 'Incomplete Preferences'.tr,
        message:
            'Please select a business type.'.tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    if (categories.isEmpty) {
      print(
        '❌ Categories are empty.',
      );

      AppSnackbar.show(
        title: 'Incomplete Preferences'.tr,
        message:
            'Please select at least one product category.'.tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    isLoading.value = true;

    try {
      // ==========================================================
      // GET FACILITY / ROLE
      // ==========================================================

      final facilityName =
          await PrefHelper.getClientBusinessName();

      final role =
          await PrefHelper.getUserRole() ?? 'client';

      print('');
      print(
        '📌 DATA THAT WILL BE SENT TO EXISTING ENDPOINT',
      );

      print(
        '🏢 Facility Name: $facilityName',
      );

      print(
        '👤 Role: $role',
      );

      print(
        '🏪 Business Type: $businessType',
      );

      print(
        '📦 Categories: $categories',
      );

      // ==========================================================
      // EXISTING ENDPOINT
      // ==========================================================

      final result =
          await _clientOnboardingRepo.savePreferences(
        facilityName: facilityName,
        role: role,
        businessType: businessType,
        categories: categories,
      );

      // ==========================================================
      // SERVER RESPONSE
      // ==========================================================

      print('');
      print(
        '════════════════════════════════════════',
      );
      print(
        '📥 RESPONSE FROM DATABASE / API',
      );
      print(
        '════════════════════════════════════════',
      );

      print(
        '💬 Message: ${result.message}',
      );

      print(
        '🏢 Facility ID: ${result.facility.id}',
      );

      print(
        '🏢 Facility Name: ${result.facilityName}',
      );

      print(
        '🏪 Business Type returned: '
        '${result.facility.businessType}',
      );

      final returnedCategories =
          result.facility.categories
              .map(
                (category) => category.name.trim(),
              )
              .toList();

      print(
        '📦 Categories returned: '
        '$returnedCategories',
      );

      // ==========================================================
      // VERIFY SERVER RESPONSE
      // ==========================================================

      final sentCategories =
          [...categories]..sort();

      final databaseCategories =
          [...returnedCategories]..sort();

      final businessTypeMatches =
          result.facility.businessType.trim() ==
          businessType;

      final categoriesMatch =
          sentCategories.length ==
              databaseCategories.length &&
          sentCategories.every(
            (category) =>
                databaseCategories.contains(category),
          );

      print('');
      print(
        '════════════════════════════════════════',
      );
      print(
        '🔍 DATABASE UPDATE VERIFICATION',
      );
      print(
        '════════════════════════════════════════',
      );

      print(
        '📤 SENT BUSINESS TYPE: $businessType',
      );

      print(
        '📥 DATABASE BUSINESS TYPE: '
        '${result.facility.businessType}',
      );

      print(
        '📤 SENT CATEGORIES: $categories',
      );

      print(
        '📥 DATABASE CATEGORIES: '
        '$returnedCategories',
      );

      print(
        '🏪 Business Type matches: '
        '$businessTypeMatches',
      );

      print(
        '📦 Categories match: '
        '$categoriesMatch',
      );

      // ==========================================================
      // SUCCESS
      // ==========================================================

      if (businessTypeMatches &&
          categoriesMatch) {
        print('');
        print(
          '✅✅✅ DATABASE UPDATE VERIFIED ✅✅✅',
        );

        print(
          'The database response contains the NEW values selected in the UI.',
        );

        print(
          '════════════════════════════════════════',
        );

        // --------------------------------------------------------
        // SAVE SERVER VALUES LOCALLY
        // --------------------------------------------------------

        await PrefHelper.saveBusinessType(
          result.facility.businessType,
        );

        await PrefHelper.saveBusinessCategories(
          returnedCategories,
        );

        await PrefHelper.saveClientBusinessType(
          result.facility.businessType,
        );

        await PrefHelper.saveClientSelectedProducts(
          returnedCategories,
        );

        // --------------------------------------------------------
        // UPDATE BOTH CONTROLLERS FROM SERVER
        // --------------------------------------------------------

        editBusinessType.value =
            result.facility.businessType;

        editBusinessCategories.assignAll(
          returnedCategories,
        );

        completion.selectedBusinessType.value =
            result.facility.businessType;

        completion.selectedProducts.assignAll(
          returnedCategories,
        );

        print('');
        print(
          '💾 LOCAL STORAGE UPDATED FROM SERVER RESPONSE',
        );

        print(
          '🏪 Business Type: '
          '${editBusinessType.value}',
        );

        print(
          '📦 Categories: '
          '${editBusinessCategories.toList()}',
        );

        print('');
        print(
          '════════ UPDATE SUCCESS ════════',
        );

        Get.back();

        AppSnackbar.show(
          title: 'Preferences Updated'.tr,
          message: result.message.tr,
          icon: Icons.check_circle_outline,
        );
      }

      // ==========================================================
      // FAILED VERIFICATION
      // ==========================================================

      else {
        print('');
        print(
          '❌❌❌ DATABASE UPDATE NOT VERIFIED ❌❌❌',
        );

        print(
          'The server returned values different from what was selected.',
        );

        print(
          '════════════════════════════════════════',
        );

        AppSnackbar.show(
          title: 'Update Verification Failed'.tr,
          message:
              'The server did not return the new preferences.'.tr,
          icon: Icons.error_outline,
        );
      }
    } catch (e, stackTrace) {
      print('');
      print(
        '════════════════════════════════════════',
      );
      print(
        '❌ UPDATE PREFERENCES ERROR',
      );
      print(
        '════════════════════════════════════════',
      );

      print('Error: $e');
      print('Type: ${e.runtimeType}');
      print('StackTrace:');
      print(stackTrace);

      print(
        '════════════════════════════════════════',
      );

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
  // FRIENDLY ERROR MESSAGE
  // ============================================================

  String _getFriendlyErrorMessage(dynamic error) {
    String msg = '';

    if (error is ApiError) {
      msg = error.message;
    } else {
      msg = error
          .toString()
          .replaceAll('Exception: ', '');
    }

    if (msg.contains('email_already_exists') ||
        msg.contains('taken')) {
      return 'This email address is already registered to another account.'
          .tr;
    }

    if (msg.contains('phone_already_exists') ||
        msg.contains('phone_number_taken')) {
      return 'This phone number is already registered to another account.'
          .tr;
    }

    return msg.tr;
  }

  // ============================================================
  // EMAIL RESEND TIMER
  // ============================================================

  void startResendTimer() {
    isResendEnabled.value = false;
    secondsRemaining.value = 60;

    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          isResendEnabled.value = true;
          timer.cancel();
        }
      },
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void goToEmail() {
    newEmailController.clear();

    Get.to(
      () => ChangeEmail(),
    );
  }

  void goToPhone() {
    Get.to(
      () => ChangePhone(),
    );
  }

  void goToPassword() {
    Get.to(
      () => ChangePassword(),
    );
  }

  void goToPreferences() {
    Get.to(
      () => const ChangePreferences(),
    );
  }

  void goToBusiness() {
    Get.to(
      () => ChangeBusinessName(),
    );
  }

  void goToEmailVerification() {
    Get.to(
      () => const VerifyNewEmail(),
    );

    startResendTimer();
  }

  // ============================================================
  // CHANGE PHONE NUMBER
  // ============================================================

  Future<void> changePhoneNumber() async {
    final newPhone =
        phoneController.text.trim();

    if (newPhone.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message:
            'Please enter your phone number'.tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    final phoneRegex =
        RegExp(r'^09\d{8}$');

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
        message:
            'Please enter a different phone number'.tr,
        icon: Icons.info_outline,
      );

      return;
    }

    isLoading.value = true;

    try {
      final result =
          await _clientOnboardingRepo.changePhoneNumber(
        phoneNumber: newPhone,
      );

      phone.value = result.phoneNumber;

      phoneController.text =
          result.phoneNumber;

      await PrefHelper.saveUserPhone(
        result.phoneNumber,
      );

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

    final targetEmail =
        newEmailController.text.trim();

    if (targetEmail == email.value) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message:
            'Please enter a different email address'.tr,
        icon: Icons.info_outline,
      );

      return;
    }

    isLoading.value = true;

    try {
      await _authRepo.requestClientEmailChange(
        email: targetEmail,
      );

      pendingEmail.value = targetEmail;

      goToEmailVerification();

      AppSnackbar.show(
        title: 'Verification Link Sent'.tr,
        message:
            'We sent a verification link to your new email address.'
                .tr,
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
    isLoading.value = true;

    try {
      email.value = pendingEmail.value;

      emailController.text =
          pendingEmail.value;

      await PrefHelper.saveUserEmail(
        pendingEmail.value,
      );

      pendingEmail.value = '';

      timer?.cancel();

      Get.back();
      Get.back();

      AppSnackbar.show(
        title: 'Email Updated'.tr,
        message:
            'Your email address was updated successfully'.tr,
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
  // RESEND EMAIL VERIFICATION
  // ============================================================

  Future<void> resendEmailCode() async {
    if (!isResendEnabled.value) {
      return;
    }

    isLoading.value = true;

    try {
      await _authRepo.requestClientEmailChange(
        email: pendingEmail.value,
      );

      startResendTimer();

      AppSnackbar.show(
        title: 'Email Sent'.tr,
        message:
            'A new verification link has been sent to your email'
                .tr,
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

    isLoading.value = true;

    try {
      businessName.value =
          businessNameController.text.trim();

      await PrefHelper.saveBusinessName(
        businessName.value,
      );

      Get.back();

      AppSnackbar.show(
        title: 'Success'.tr,
        message: 'Personal info updated'.tr,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Error'.tr,
        message:
            'Something went wrong. Please try again'.tr,
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

    isLoading.value = true;

    try {
      email.value =
          emailController.text.trim();

      phone.value =
          phoneController.text.trim();

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
        message:
            'Something went wrong. Please try again'.tr,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SAVE PREFERENCES
  // ============================================================

  Future<void> savePreferences() async {
    await updateBusinessPreferences();
  }

  // ============================================================
  // PASSWORD VISIBILITY
  // ============================================================

  void togglePasswordVisibility() {
    obscurePassword.value =
        !obscurePassword.value;
  }
// ============================================================
// UPDATE BUSINESS NAME
// ============================================================

Future<void> updateBusinessName() async {
  final newName = businessName.value.trim();

  print('');
  print('════════ UPDATE BUSINESS NAME ════════');
  print('🏢 New Business Name: $newName');

  // ============================================================
  // VALIDATION
  // ============================================================

  if (newName.isEmpty) {
    print('❌ Business name is empty');

    AppSnackbar.show(
      title: 'Required'.tr,
      message: 'Please enter a business name'.tr,
      icon: Icons.warning_amber_rounded,
    );

    return;
  }

  if (newName.length < 2) {
    print('❌ Business name is less than 2 characters');

    AppSnackbar.show(
      title: 'Invalid Business Name'.tr,
      message:
          'Business name must contain at least 2 characters'.tr,
      icon: Icons.warning_amber_rounded,
    );

    return;
  }

  if (newName == selectedBusinessName.value.trim()) {
    print('❌ Business name has not changed');

    AppSnackbar.show(
      title: 'No Changes'.tr,
      message:
          'Please enter a different business name'.tr,
      icon: Icons.info_outline,
    );

    return;
  }

  // ============================================================
  // GET FACILITY ID
  // ============================================================

  final facilityId =
      await PrefHelper.getClientFacilityId();

  if (facilityId == null) {
    print('❌ Facility ID is null');

    AppSnackbar.show(
      title: 'Error'.tr,
      message:
          'Unable to find your business facility.'.tr,
      icon: Icons.error_outline,
    );

    return;
  }

  print('🏢 Facility ID: $facilityId');

  // ============================================================
  // LOADING
  // ============================================================

  if (isLoading.value) {
    return;
  }

  isLoading.value = true;

  try {
    print('');
    print('📤 DATA SENT TO API');
    print('🏢 Facility ID: $facilityId');
    print('🏢 New Name: $newName');

    // ==========================================================
    // API REQUEST
    // ==========================================================

    final result =
        await _clientOnboardingRepo.updateBusinessName(
      businessName: newName,
      facilityId: facilityId,
    );

    print('');
    print('════════ BUSINESS NAME RESPONSE ════════');
    print('💬 Message: ${result.message}');
    print('🏢 Facility ID: ${result.facility.id}');
    print(
      '🏢 Business Name EN: '
      '${result.facility.facilityNameEn}',
    );
    print(
      '🏢 Business Name AR: '
      '${result.facility.facilityNameAr}',
    );

    // ==========================================================
    // IMPORTANT
    // ==========================================================
    //
    // The backend currently returns null for both
    // facility_name_en and facility_name_ar.
    //
    // Therefore we use the name WE SENT if the server
    // doesn't return the updated name.
    // ==========================================================

    final returnedName =
        result.facility.facilityNameEn?.trim();

    final finalBusinessName =
        returnedName != null &&
                returnedName.isNotEmpty
            ? returnedName
            : newName;

    print(
      '🏢 Final Business Name: $finalBusinessName',
    );

    // ==========================================================
    // UPDATE CONTROLLER
    // ==========================================================

    businessName.value =
        finalBusinessName;

    selectedBusinessName.value =
        finalBusinessName;

    businessNameController.text =
        finalBusinessName;

    // ==========================================================
    // UPDATE LOCAL STORAGE
    // ==========================================================

    await PrefHelper.saveBusinessName(
      finalBusinessName,
    );

    await PrefHelper.saveClientBusinessName(
      finalBusinessName,
    );

    print('');
    print('💾 LOCAL BUSINESS NAME UPDATED');
    print(
      '🏢 Business Name: $finalBusinessName',
    );

    // ==========================================================
    // CLOSE PAGE
    // ==========================================================

    Get.back();

    AppSnackbar.show(
      title:
          'Business Name Updated'.tr,
      message:
          result.message.tr,
      icon:
          Icons.check_circle_outline,
    );

    print('');
    print(
      '════════ BUSINESS NAME UPDATE SUCCESS ════════',
    );
  } catch (e, stackTrace) {
    print('');
    print(
      '════════ BUSINESS NAME UPDATE ERROR ════════',
    );

    print('❌ Error: $e');
    print('❌ Type: ${e.runtimeType}');
    print('❌ StackTrace:');
    print(stackTrace);

    AppSnackbar.show(
      title:
          'Business Name Update Failed'.tr,
      message:
          _getFriendlyErrorMessage(e),
      icon:
          Icons.error_outline,
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