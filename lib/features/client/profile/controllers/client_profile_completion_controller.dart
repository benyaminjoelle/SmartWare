import 'package:get/get.dart';

class ClientProfileCompletionController extends GetxController {
  /// =========================================================
  /// STEPS
  /// =========================================================

  final currentStep = 0.obs;
  final int totalSteps = 3;

  /// step-based progress map
  final List<int> stepProgress = [0, 33, 66, 100];

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
      _syncProgress();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      _syncProgress();
    }
  }

  bool get isFirstStep => currentStep.value == 0;

  bool get isLastStep => currentStep.value == totalSteps - 1;

  /// =========================================================
  /// PROFILE COMPLETION
  /// =========================================================

  final profileCompletion = 0.obs;
  static const int maxCompletion = 100;

  double get completionPercent =>
      profileCompletion.value / maxCompletion;

  bool get isProfileComplete =>
      profileCompletion.value >= maxCompletion;

  String get completionText {
    final v = profileCompletion.value;

    if (v >= 100) return "Profile Complete";
    if (v >= 80) return "Almost Done";
    if (v >= 50) return "Keep Going";
    return "Complete Your Profile";
  }

  /// =========================================================
  /// STEP → PROGRESS SYNC (CORE ENGINE)
  /// =========================================================

  void _syncProgress() {
    profileCompletion.value =
        stepProgress[currentStep.value];
  }

  /// =========================================================
  /// 🔥 STEP 1: PREFERENCES DATA (NEW)
  /// =========================================================

  final businessCategory = "".obs; // Retail / Food / etc
  final preferredLanguage = "English".obs;
  final preferredCurrency = "USD".obs;

  /// OPTIONAL: multi-select categories (future upgrade)
  final selectedCategories = <String>[].obs;

  void toggleCategory(String value) {
    if (selectedCategories.contains(value)) {
      selectedCategories.remove(value);
    } else {
      selectedCategories.add(value);
    }
  }

  /// =========================================================
  /// STEP 2: LOCATION DATA (PLACEHOLDER FOR NEXT STEP)
  /// =========================================================

  final address = "".obs;
  final city = "".obs;
  final country = "".obs;

  /// =========================================================
  /// STEP 3: DOCUMENTATION DATA (PLACEHOLDER)
  /// =========================================================

  final businessLicenseUploaded = false.obs;
  final taxIdUploaded = false.obs;
  final registrationDocUploaded = false.obs;

  void markLicenseUploaded() => businessLicenseUploaded.value = true;
  void markTaxUploaded() => taxIdUploaded.value = true;
  void markRegistrationUploaded() =>
      registrationDocUploaded.value = true;

  /// =========================================================
  /// VALIDATION HOOKS (FOR LATER UI BLOCKING)
  /// =========================================================

  bool get canGoNext {
    switch (currentStep.value) {
      case 0:
        return businessCategory.isNotEmpty;
      case 1:
        return address.isNotEmpty && city.isNotEmpty;
      case 2:
        return businessLicenseUploaded.value;
      default:
        return true;
    }
  }

  /// =========================================================
  /// RESET (for testing or re-onboarding)
  /// =========================================================

  void reset() {
    currentStep.value = 0;
    profileCompletion.value = 0;

    businessCategory.value = "";
    preferredLanguage.value = "English";
    preferredCurrency.value = "USD";

    selectedCategories.clear();

    address.value = "";
    city.value = "";
    country.value = "";

    businessLicenseUploaded.value = false;
    taxIdUploaded.value = false;
    registrationDocUploaded.value = false;

    _syncProgress();
  }

  /// =========================================================
  /// DEMO
  /// =========================================================

  void simulateProgress() {
    nextStep();
  }
}