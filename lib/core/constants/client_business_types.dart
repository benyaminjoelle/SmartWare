import 'package:flutter/material.dart';
import 'package:smartware/features/client/profile/widgets/business_type_model.dart';

class BusinessTypes {
  static final List<BusinessTypeModel> all = [
    const BusinessTypeModel(
      id: 'restaurant',
      title: 'Restaurant',
      subtitle: 'Restaurants, cafés and food services',
      icon: Icons.restaurant_rounded,
    ),

    const BusinessTypeModel(
      id: 'pharmacy',
      title: 'Pharmacy',
      subtitle: 'Medicines and healthcare products',
      icon: Icons.local_pharmacy_rounded,
    ),

    const BusinessTypeModel(
      id: 'clothing_store',
      title: 'Clothing Store',
      subtitle: 'Fashion, shoes and accessories',
      icon: Icons.checkroom_rounded,
    ),

    const BusinessTypeModel(
      id: 'electronics_store',
      title: 'Electronics',
      subtitle: 'Phones, computers and accessories',
      icon: Icons.devices_rounded,
    ),

    const BusinessTypeModel(
      id: 'supermarket',
      title: 'Supermarket',
      subtitle: 'Groceries and daily essentials',
      icon: Icons.local_grocery_store_rounded,
    ),

    const BusinessTypeModel(
      id: 'makeup_store',
      title: 'Makeup Store',
      subtitle: 'Beauty and cosmetic products',
      icon: Icons.face_retouching_natural_rounded,
    ),

    const BusinessTypeModel(
      id: 'furniture_store',
      title: 'Furniture Store',
      subtitle: 'Home and office furniture',
      icon: Icons.chair_alt_rounded,
    ),
  ];
}