import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Added for disk retrieval
import 'package:smartware/features/auth/models/user_model.dart';

class ClientHomeController extends GetxController {
  late UserModel user; 
  
  // Clean Getters using Option 1 (Disk Storage)
  String get userName => user.firstName ?? "User";
  List<String> get userOnboardingSectors => ['foods', 'cleaning'];

  //until i have the list from backend
  // List<String> get userOnboardingSectors => user.sectors ?? ['foods', 'cleaning'];

  // This would typically come from your backend database repository
  final List<SubCategory> _allAvailableSubCategories = [
    SubCategory(id: '1', parentSector: 'foods', name: 'Pantry'),
    SubCategory(id: '2', parentSector: 'foods', name: 'Dairy'),
    SubCategory(id: '3', parentSector: 'foods', name: 'Baking'),
    SubCategory(id: '4', parentSector: 'cleaning', name: 'Glass Cleaners'),
    SubCategory(id: '5', parentSector: 'cleaning', name: 'Detergents'),
    SubCategory(id: '6', parentSector: 'cleaning', name: 'Liquid Soaps'),
    SubCategory(id: '7', parentSector: 'electronics', name: 'Phones'), // Will be filtered out
  ];

  // The final reactive list that the horizontal row will look at
  final RxList<SubCategory> filteredSubCategories = <SubCategory>[].obs;
  
  // Tracks which specific filter tag is currently selected (null means "All")
  final RxnString selectedSubCategoryId = RxnString();

  @override
  void onInit() {
    super.onInit();
    
    // 1. Retrieve the saved user map from local storage immediately on startup
    final box = GetStorage();
    final Map<String, dynamic> responseMap = box.read('user_data') ?? {};
    
    // 2. Safely unpack JSON to create your runtime User instance 
    user = UserModel.fromJson(responseMap);
    
    // 3. Now that the user instance is live, securely process the sector filters
    loadUserSubCategories();
  }

  void loadUserSubCategories() {
    // Filter the master list to only include sub-categories matching onboarding choices
    final matchedItems = _allAvailableSubCategories.where((sub) {
      return userOnboardingSectors.contains(sub.parentSector);
    }).toList();

    filteredSubCategories.assignAll(matchedItems);
  }

  void selectSubCategory(String id) {
    if (selectedSubCategoryId.value == id) {
      selectedSubCategoryId.value = null; // Deselect if tapped again (Show All)
    } else {
      selectedSubCategoryId.value = id;
    }
    
    // TODO: Trigger your warehouse items filter query here based on the selected ID
  }
}

// This should be in the model file later
class SubCategory {
  final String id;
  final String parentSector; // e.g., 'foods', 'cleaning'
  final String name;

  SubCategory({required this.id, required this.parentSector, required this.name});
}