import 'package:flutter/material.dart';
import 'package:smartware/features/client/profile/widgets/product_type_model.dart';

class ProductTypes {
  static final List<ProductTypeModel> all = [

    // ================= FOOD =================

    const ProductTypeModel(
      id: 'canned_foods',
      title: 'Canned Foods',
      icon: Icons.inventory_2_rounded,
    ),

    const ProductTypeModel(
      id: 'fresh_foods',
      title: 'Fresh Foods',
      icon: Icons.eco_rounded,
    ),

    const ProductTypeModel(
      id: 'refrigerated_foods',
      title: 'Refrigerated Foods',
      icon: Icons.ac_unit_rounded,
    ),

    const ProductTypeModel(
      id: 'frozen_foods',
      title: 'Frozen Foods',
      icon: Icons.kitchen_rounded,
    ),

    const ProductTypeModel(
      id: 'beverages',
      title: 'Beverages',
      icon: Icons.local_drink_rounded,
    ),

    const ProductTypeModel(
      id: 'coffee_tea',
      title: 'Coffee & Tea',
      icon: Icons.coffee_rounded,
    ),

    const ProductTypeModel(
      id: 'bakery_products',
      title: 'Bakery Products',
      icon: Icons.bakery_dining_rounded,
    ),

    const ProductTypeModel(
      id: 'spices_seasonings',
      title: 'Spices & Seasonings',
      icon: Icons.restaurant_menu_rounded,
    ),

    const ProductTypeModel(
      id: 'meat_poultry',
      title: 'Meat & Poultry',
      icon: Icons.set_meal_rounded,
    ),

    const ProductTypeModel(
      id: 'seafood',
      title: 'Seafood',
      icon: Icons.set_meal_outlined,
    ),

    const ProductTypeModel(
      id: 'dairy_products',
      title: 'Dairy Products',
      icon: Icons.egg_alt_rounded,
    ),

    const ProductTypeModel(
      id: 'packaging_supplies',
      title: 'Packaging Supplies',
      icon: Icons.inventory_rounded,
    ),

    const ProductTypeModel(
      id: 'cleaning_supplies',
      title: 'Cleaning Supplies',
      icon: Icons.cleaning_services_rounded,
    ),


    // ================= PHARMACY =================

    const ProductTypeModel(
      id: 'prescription_medicine',
      title: 'Prescription Medicine',
      icon: Icons.medication_rounded,
    ),

    const ProductTypeModel(
      id: 'over_the_counter_medicine',
      title: 'Over The Counter Medicine',
      icon: Icons.local_pharmacy_rounded,
    ),

    const ProductTypeModel(
      id: 'vitamins_supplements',
      title: 'Vitamins & Supplements',
      icon: Icons.vaccines_rounded,
    ),

    const ProductTypeModel(
      id: 'medical_equipment',
      title: 'Medical Equipment',
      icon: Icons.medical_services_rounded,
    ),

    const ProductTypeModel(
      id: 'first_aid_supplies',
      title: 'First Aid Supplies',
      icon: Icons.health_and_safety_rounded,
    ),

    const ProductTypeModel(
      id: 'baby_care',
      title: 'Baby Care',
      icon: Icons.child_care_rounded,
    ),

    const ProductTypeModel(
      id: 'personal_care',
      title: 'Personal Care',
      icon: Icons.person_rounded,
    ),

    const ProductTypeModel(
      id: 'health_products',
      title: 'Health Products',
      icon: Icons.favorite_rounded,
    ),

    const ProductTypeModel(
      id: 'surgical_supplies',
      title: 'Surgical Supplies',
      icon: Icons.health_and_safety_rounded,
    ),


    // ================= CLOTHING =================

    const ProductTypeModel(
      id: 'mens_clothing',
      title: "Men's Clothing",
      icon: Icons.man_rounded,
    ),

    const ProductTypeModel(
      id: 'womens_clothing',
      title: "Women's Clothing",
      icon: Icons.woman_rounded,
    ),

    const ProductTypeModel(
      id: 'kids_clothing',
      title: "Kids Clothing",
      icon: Icons.child_friendly_rounded,
    ),

    const ProductTypeModel(
      id: 'shoes',
      title: 'Shoes',
      icon: Icons.shopping_bag_rounded,
    ),

    const ProductTypeModel(
      id: 'bags',
      title: 'Bags',
      icon: Icons.work_outline_rounded,
    ),

    const ProductTypeModel(
      id: 'accessories',
      title: 'Accessories',
      icon: Icons.watch_rounded,
    ),

    const ProductTypeModel(
      id: 'jewelry',
      title: 'Jewelry',
      icon: Icons.diamond_rounded,
    ),

    const ProductTypeModel(
      id: 'sportswear',
      title: 'Sportswear',
      icon: Icons.sports_rounded,
    ),

    const ProductTypeModel(
      id: 'underwear',
      title: 'Underwear',
      icon: Icons.checkroom_rounded,
    ),

    const ProductTypeModel(
      id: 'seasonal_fashion',
      title: 'Seasonal Fashion',
      icon: Icons.style_rounded,
    ),

    const ProductTypeModel(
      id: 'fabric_materials',
      title: 'Fabric Materials',
      icon: Icons.texture_rounded,
    ),


    // ================= ELECTRONICS =================

    const ProductTypeModel(
      id: 'smartphones',
      title: 'Smartphones',
      icon: Icons.smartphone_rounded,
    ),

    const ProductTypeModel(
      id: 'laptops',
      title: 'Laptops',
      icon: Icons.laptop_rounded,
    ),

    const ProductTypeModel(
      id: 'tablets',
      title: 'Tablets',
      icon: Icons.tablet_rounded,
    ),

    const ProductTypeModel(
      id: 'desktop_computers',
      title: 'Desktop Computers',
      icon: Icons.desktop_windows_rounded,
    ),

    const ProductTypeModel(
      id: 'computer_accessories',
      title: 'Computer Accessories',
      icon: Icons.keyboard_rounded,
    ),

    const ProductTypeModel(
      id: 'phone_accessories',
      title: 'Phone Accessories',
      icon: Icons.cable_rounded,
    ),

    const ProductTypeModel(
      id: 'audio_devices',
      title: 'Audio Devices',
      icon: Icons.headphones_rounded,
    ),

    const ProductTypeModel(
      id: 'gaming_devices',
      title: 'Gaming Devices',
      icon: Icons.sports_esports_rounded,
    ),

    const ProductTypeModel(
      id: 'cameras',
      title: 'Cameras',
      icon: Icons.camera_alt_rounded,
    ),

    const ProductTypeModel(
      id: 'smart_home_devices',
      title: 'Smart Home Devices',
      icon: Icons.home_rounded,
    ),

    const ProductTypeModel(
      id: 'network_equipment',
      title: 'Network Equipment',
      icon: Icons.router_rounded,
    ),

    const ProductTypeModel(
      id: 'electronic_parts',
      title: 'Electronic Parts',
      icon: Icons.memory_rounded,
    ),

    const ProductTypeModel(
      id: 'batteries',
      title: 'Batteries',
      icon: Icons.battery_full_rounded,
    ),


    // ================= SUPERMARKET =================

    const ProductTypeModel(
      id: 'fruits_vegetables',
      title: 'Fruits & Vegetables',
      icon: Icons.local_grocery_store_rounded,
    ),

    const ProductTypeModel(
      id: 'snacks',
      title: 'Snacks',
      icon: Icons.cookie_rounded,
    ),

    const ProductTypeModel(
      id: 'household_items',
      title: 'Household Items',
      icon: Icons.home_work_rounded,
    ),

    const ProductTypeModel(
      id: 'baby_products',
      title: 'Baby Products',
      icon: Icons.child_care_rounded,
    ),

    const ProductTypeModel(
      id: 'pet_supplies',
      title: 'Pet Supplies',
      icon: Icons.pets_rounded,
    ),


    // ================= BEAUTY =================

    const ProductTypeModel(
      id: 'makeup',
      title: 'Makeup',
      icon: Icons.face_rounded,
    ),

    const ProductTypeModel(
      id: 'skincare',
      title: 'Skincare',
      icon: Icons.spa_rounded,
    ),

    const ProductTypeModel(
      id: 'hair_care',
      title: 'Hair Care',
      icon: Icons.content_cut_rounded,
    ),

    const ProductTypeModel(
      id: 'perfumes',
      title: 'Perfumes',
      icon: Icons.local_florist_rounded,
    ),

    const ProductTypeModel(
      id: 'body_care',
      title: 'Body Care',
      icon: Icons.self_improvement_rounded,
    ),

    const ProductTypeModel(
      id: 'nail_products',
      title: 'Nail Products',
      icon: Icons.back_hand_rounded,
    ),

    const ProductTypeModel(
      id: 'beauty_tools',
      title: 'Beauty Tools',
      icon: Icons.build_rounded,
    ),

    const ProductTypeModel(
      id: 'personal_hygiene',
      title: 'Personal Hygiene',
      icon: Icons.clean_hands_rounded,
    ),

    const ProductTypeModel(
      id: 'professional_beauty_products',
      title: 'Professional Beauty Products',
      icon: Icons.business_center_rounded,
    ),


    // ================= FURNITURE =================

    const ProductTypeModel(
      id: 'home_furniture',
      title: 'Home Furniture',
      icon: Icons.chair_rounded,
    ),

    const ProductTypeModel(
      id: 'office_furniture',
      title: 'Office Furniture',
      icon: Icons.business_rounded,
    ),

    const ProductTypeModel(
      id: 'bedroom_furniture',
      title: 'Bedroom Furniture',
      icon: Icons.bed_rounded,
    ),

    const ProductTypeModel(
      id: 'living_room_furniture',
      title: 'Living Room Furniture',
      icon: Icons.weekend_rounded,
    ),

    const ProductTypeModel(
      id: 'kitchen_furniture',
      title: 'Kitchen Furniture',
      icon: Icons.kitchen_rounded,
    ),

    const ProductTypeModel(
      id: 'outdoor_furniture',
      title: 'Outdoor Furniture',
      icon: Icons.deck_rounded,
    ),

    const ProductTypeModel(
      id: 'lighting',
      title: 'Lighting',
      icon: Icons.light_rounded,
    ),

    const ProductTypeModel(
      id: 'home_decor',
      title: 'Home Decor',
      icon: Icons.home_work_rounded,
    ),

    const ProductTypeModel(
      id: 'mattresses',
      title: 'Mattresses',
      icon: Icons.bedroom_parent_rounded,
    ),

    const ProductTypeModel(
      id: 'wood_materials',
      title: 'Wood Materials',
      icon: Icons.forest_rounded,
    ),

    const ProductTypeModel(
      id: 'furniture_accessories',
      title: 'Furniture Accessories',
      icon: Icons.settings_rounded,
    ),
  ];
}