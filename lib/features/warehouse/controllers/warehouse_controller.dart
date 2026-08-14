import 'package:get/get.dart';
import 'package:smartware/features/warehouse/models/warehouse_model.dart';

class WarehouseController extends GetxController {
  final warehouses = <Warehouse>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockWarehouses();
  }

  void loadMockWarehouses() {
    warehouses.assignAll([
      Warehouse(
        id: 'wh_001',
        name: 'Central Distribution Hub',
        address: 'Industrial Zone, Block 4, Bldg 12',
        city: 'Damascus',
        phone: '+963 11 555 0192',
        managerName: 'Samer Haddad',
        totalCapacityUnits: 50000,
        currentOccupiedUnits: 38200,
      
        latitude: 33.5138,
        longitude: 36.2765,
      ),
      Warehouse(
        id: 'wh_002',
        name: 'Northern Port Depot',
        address: 'Free Zone Area, Dock 3',
        city: 'Lattakia',
        phone: '+963 41 444 8821',
        managerName: 'Kareem Mansour',
        totalCapacityUnits: 30000,
        currentOccupiedUnits: 14500,
        latitude: 35.5317,
        longitude: 35.7915,
      ),
      Warehouse(
        id: 'wh_003',
        name: 'Southern Commercial Warehouse',
        address: 'Main Highway Exit 7',
        city: 'Daraa',
        phone: '+963 15 222 3411',
        managerName: 'Nour El-Din',
        totalCapacityUnits: 20000,
        currentOccupiedUnits: 19100, // Almost full (95.5%)
        latitude: 32.6255,
        longitude: 36.1018,
      ),
      Warehouse(
        id: 'wh_004',
        name: 'Central Coast Storage',
        address: 'Industrial City, Plot 88',
        city: 'Homs',
        phone: '+963 31 333 9012',
        managerName: 'Rania Kassam',
        totalCapacityUnits: 25000,
        currentOccupiedUnits: 8000,
        latitude: 34.7324,
        longitude: 36.7137,
      ),
    ]);
  }
}