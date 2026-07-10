import 'package:get/get.dart';

class ClientHomeController extends GetxController{
  
  final List<String> userOnboardingSectors = ['foods', 'cleaning'];

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
//this should be in the model file later
class SubCategory {
  final String id;
  final String parentSector; // e.g., 'foods', 'cleaning'
  final String name;

  SubCategory({required this.id, required this.parentSector, required this.name});
}
