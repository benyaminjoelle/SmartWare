import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';

class ClientHomeController extends GetxController {
  late UserModel user;

  String get userName => user.firstName;

  List<String> get userOnboardingSectors => [
        'foods',
        'cleaning',
      ];

  final List<SubCategory> _allAvailableSubCategories = [
    SubCategory(
      id: '1',
      parentSector: 'foods',
      name: 'Pantry'),
    SubCategory(
      id: '2',
      parentSector: 'foods',
      name: 'Dairy'),
    SubCategory(
      id: '3',
      parentSector: 'foods',
      name: 'Baking'),
    SubCategory(
      id: '4',
      parentSector: 'cleaning',
      name: 'Glass Cleaners'),
    SubCategory(
      id: '5',
      parentSector: 'cleaning',
      name: 'Detergents'),
    SubCategory(
      id: '6',
      parentSector: 'cleaning',
      name: 'Liquid Soaps'),
    SubCategory(
      id: '7',
      parentSector: 'electronics',
      name: 'Phones'),
  ];

  final RxList<SubCategory> filteredSubCategories =
      <SubCategory>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadUser();

    loadUserSubCategories();
  }

  void loadUser() {
    final box = GetStorage();

    final Map<String, dynamic> responseMap =
        box.read('user_data') ?? {};

    user = UserModel.fromJson(responseMap);
  }

  void loadUserSubCategories() {
    final matchedItems =
        _allAvailableSubCategories.where((sub) {
      return userOnboardingSectors.contains(
        sub.parentSector,
      );
    }).toList();

    filteredSubCategories.assignAll(matchedItems);
  }
}