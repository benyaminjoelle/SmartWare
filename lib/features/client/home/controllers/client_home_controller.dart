import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Added for disk retrieval
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/features/product/models/product_model.dart';

class ClientHomeController extends GetxController {
  late UserModel user; 
  

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
    SubCategory(id: '7', parentSector: 'electronics', name: 'Phones'), 
  ];
  // mock data until backend integration
  final List<Product> products = [
    Product(
      sku: 'FO-PAN-01',
      name: 'Olive Oil',
      price: 12.50,
      discountPercentage: 10,
      containerType: 'Glass Bottle',
      productType: 'foods',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      sku: 'CL-DET-01',
      name: 'Liquid Detergent',
      price: 8.99,
      discountPercentage: 5,
      containerType: 'Plastic Jug',
      productType: 'cleaning',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      sku: 'FO-DAI-01',
      name: 'Cheddar Cheese',
      price: 5.50,
      containerType: 'Plastic Wrap',
      productType: 'foods',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      sku: 'FO-PAN-02',
      name: 'Basmati Rice',
      price: 18.00,
      containerType: 'Plastic Bag',
      productType: 'foods',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      sku: 'CL-GLA-01',
      name: 'Window Spray',
      price: 4.20,
      containerType: 'Plastic Spray Bottle',
      productType: 'cleaning',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      sku: 'CL-DET-01',
      name: 'Laundry Liquid',
      price: 15.00,
      containerType: 'Plastic Jug',
      productType: 'cleaning',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  // The final reactive list that the horizontal row will look at
  final RxList<SubCategory> filteredSubCategories = <SubCategory>[].obs;
  final RxList<Product> displayedProducts = <Product>[].obs;
  final RxnString selectedSubCategoryId = RxnString();

  // ================= FILTER STATES =================
  final RxSet<String> selectedContainerTypes = <String>{}.obs;
  final RxSet<String> selectedProductTypes = <String>{}.obs;
  final RxString searchQuery = ''.obs;

  double minPossiblePrice = 0.0;
  double maxPossiblePrice = 100.0;
  late Rx<RangeValues> priceRange;

  @override
  void onInit() {
    super.onInit();  
    final box = GetStorage();
    final Map<String, dynamic> responseMap = box.read('user_data') ?? {};
    
    user = UserModel.fromJson(responseMap);
    
    calculatePriceBounds();
    loadUserSubCategories();
    loadProducts();

  //
    debounce(
    searchQuery,
    (_) => applyFilters(),
    time: const Duration(milliseconds: 300),
  );
  }
  void calculatePriceBounds() {
    if (products.isNotEmpty) {
      minPossiblePrice = products.map((p) => p.price).reduce((a, b) => a < b ? a : b);
      maxPossiblePrice = products.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    }
    priceRange = RangeValues(minPossiblePrice, maxPossiblePrice).obs;
  }
  //========= SEARCH FUNCTION =========
  void updateSearchQuery(String query) {
  searchQuery.value = query;
}
  void loadProducts() {
   //include products matching filtering choices
    final initialProducts = products.where((product) {
      return userOnboardingSectors.contains(product.productType);
    }).toList();

    displayedProducts.assignAll(initialProducts);
  }
  List<String> get availableContainerTypes {
    return products.map((p) => p.containerType).toSet().toList();
  }

  void loadUserSubCategories() {
    //include choinces matching onboarding choices
    final matchedItems = _allAvailableSubCategories.where((sub) {
      return userOnboardingSectors.contains(sub.parentSector);
    }).toList();

    filteredSubCategories.assignAll(matchedItems);
  }
//================= FILTERING LOGIC =================
  void applyFilters() {
    final filtered = products.where((product) {

    final query = searchQuery.value.trim().toLowerCase();
    final matchesSearch = query.isEmpty ||
        product.name.toLowerCase().contains(query) ||
        product.sku.toLowerCase().contains(query);
     
      final allowedSectors = selectedProductTypes.isEmpty 
          ? userOnboardingSectors 
          : selectedProductTypes;
      
      final matchesType = allowedSectors.contains(product.productType);

      //container type filter
      final matchesContainer = selectedContainerTypes.isEmpty ||
          selectedContainerTypes.contains(product.containerType);

      //price range filter
      final matchesPrice = product.price >= priceRange.value.start &&
          product.price <= priceRange.value.end;

      return matchesType && matchesContainer && matchesPrice && matchesSearch;
    }).toList();

    displayedProducts.assignAll(filtered);
  }

  void toggleContainerType(String type) {
    if (selectedContainerTypes.contains(type)) {
      selectedContainerTypes.remove(type);
    } else {
      selectedContainerTypes.add(type);
    }
  }

  void toggleProductType(String type) {
    if (selectedProductTypes.contains(type)) {
      selectedProductTypes.remove(type);
    } else {
      selectedProductTypes.add(type);
    }
  }

  void resetFilters() {
    selectedContainerTypes.clear();
    selectedProductTypes.clear();
    selectedSubCategoryId.value = null;
    priceRange.value = RangeValues(minPossiblePrice, maxPossiblePrice);
    applyFilters();
  }

  void selectSubCategory(String id) {
    if (selectedSubCategoryId.value == id) {
      selectedSubCategoryId.value = null; 
    } else {
      selectedSubCategoryId.value = id;
    }
      final sub = _allAvailableSubCategories.firstWhere((s) => s.id == id); 
      final filtered = products.where((p) => 
        p.productType.toLowerCase() == sub.parentSector.toLowerCase()
      ).toList();
      
      displayedProducts.assignAll(filtered);
    
    // TODO: Trigger your warehouse items filter query here based on the selected ID
  }
}

// This should be in the model file later
class SubCategory {
  final String id;
  final String parentSector; 
  final String name;

  SubCategory({required this.id, required this.parentSector, required this.name});
}