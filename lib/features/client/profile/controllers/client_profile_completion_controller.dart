import 'package:get/get.dart';
import 'package:smartware/core/constants/business_product_mapping.dart';
import 'package:smartware/core/constants/client_business_types.dart';
import 'package:smartware/core/constants/client_products.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smartware/features/client/profile/widgets/product_type_model.dart';
import 'package:smartware/widgets/app_dialog.dart';


class ClientProfileCompletionController extends GetxController {
  /// =========================================================
  /// STEPS
  /// =========================================================

  final currentStep = 0.obs;
  final int totalSteps = 3;

  /// step-based progress map
  final List<int> stepProgress = [33, 66, 100];

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

  bool get isFirstStep => currentStep.value == 33;

  bool get isLastStep => currentStep.value == totalSteps - 1;

  /// =========================================================
  /// PROFILE COMPLETION
  /// =========================================================

  final profileCompletion = 33.obs;
  static const int maxCompletion = 100;

  double get completionPercent => profileCompletion.value / maxCompletion;

  bool get isProfileComplete => profileCompletion.value >= maxCompletion;

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
    profileCompletion.value = stepProgress[currentStep.value];
  }

  /// =========================================================
  /// 🔥 STEP 1: PREFERENCES DATA (NEW)
  /// =========================================================

  final selectedBusinessType = "".obs; // Retail / Food / etc
  final isProductsExpanded = false.obs; // Handles expanded/collapsed state dynamically
  final preferredLanguage = "English".obs;
  final preferredCurrency = "USD".obs;

  final selectedProducts = <String>[].obs;

  void toggleProduct(String id) {
    if (selectedProducts.contains(id)) {
      selectedProducts.remove(id);
    } else {
      selectedProducts.add(id);
    }

    selectedProducts.refresh();

    print(selectedProducts);
  }

  final businessTypes = BusinessTypes.all;

  final List<ProductTypeModel> allProducts = ProductTypes.all;

  final Map<String, List<String>> businessProductMap = BusinessProductMapping.map;

  void selectBusinessType(String id) {
    if (selectedBusinessType.value == id) return;

    selectedBusinessType.value = id;

    // Reset products and collapse the list whenever the business changes.
    selectedProducts.clear();
    isProductsExpanded.value = false;
  }

  List<ProductTypeModel> get availableProducts {
    final allowedIds = businessProductMap[selectedBusinessType.value] ?? [];

    return allProducts
        .where((product) => allowedIds.contains(product.id))
        .toList();
  }
  void clearBusinessType() {
    selectedBusinessType.value = "";
    selectedProducts.clear();
    isProductsExpanded.value = false;
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
Future<void> pickDocument(String type) async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
  );

  if (result != null && result.files.single.path != null) {
    final filePath = result.files.single.path!;

    if (type == 'owner_id') {
      ownerIdUploaded.value = true;
    } else if (type == 'ownership_proof') {
      ownershipProofUploaded.value = true;
    }

    print('Selected file: $filePath');
    print('Current step: ${currentStep.value}');
print('Owner ID: ${ownerIdUploaded.value}');
print('Ownership: ${ownershipProofUploaded.value}');
print('canGoNext: $canGoNext');
  }
}
  /// =========================================================
/// STEP 3: DOCUMENTATION DATA
/// =========================================================

final ownerIdUploaded = false.obs;
final ownershipProofUploaded = false.obs;

void markOwnerIdUploaded() => ownerIdUploaded.value = true;
void markOwnershipProofUploaded() =>
    ownershipProofUploaded.value = true;

void removeOwnerId() => ownerIdUploaded.value = false;
void removeOwnershipProof() => ownershipProofUploaded.value = false;
  /// =========================================================
  /// VALIDATION HOOKS (FOR LATER UI BLOCKING)
  bool get canGoNext {
    switch (currentStep.value) {
      case 0:
        return selectedBusinessType.value.isNotEmpty &&
            selectedProducts.value.isNotEmpty;

    
 case 1:
  return ownerIdUploaded.value &&
      ownershipProofUploaded.value;
        
  case 2:
        return address.value.isNotEmpty && city.value.isNotEmpty;

      default:
        return true;
    }
  }

Future<void> handleBack() async {
  if (currentStep.value == 0) {
    Get.back();
    return;
  }

  final leave = await AppDialogs.showConfirmDialog(
    title: 'Leave Profile Completion?',
    message:
        'Your progress will remain saved. Do you want to leave the profile completion process or return to the previous step?',
    confirmText: 'Leave',
    cancelText: 'Previous Step',
  );

  if (leave == true) {
    Get.back();
  } else {
    previousStep();
  }
}
  /// =========================================================
  /// RESET (for testing or re-onboarding)
  /// =========================================================

  void reset() {
    currentStep.value = 0;
    profileCompletion.value = 0;

    selectedBusinessType.value = "";
    isProductsExpanded.value = false; // Reset back to collapsed view
    preferredLanguage.value = "English";
    preferredCurrency.value = "USD";

    selectedProducts.clear();

    address.value = "";
    city.value = "";
    country.value = "";

    ownerIdUploaded.value = false;
ownershipProofUploaded.value = false;

    _syncProgress();
  }

  /// =========================================================
  /// DEMO
  /// =========================================================

  void simulateProgress() {
    nextStep();
  }
}