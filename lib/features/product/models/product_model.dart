class Product {
  final String sku;
  final String name;
  final double price;
  final double? discountPercentage;
  final String containerType;
  final String productType;
  final String imageUrl;

  Product({
    required this.sku,
    required this.name,
    required this.price,
    required this.containerType,
    required this.productType,
    required this.imageUrl,
    this.discountPercentage,
  });

  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;
  double get discountedPrice => hasDiscount ? price - (price * discountPercentage!/100) : price;
  double get savingsPerUnit => hasDiscount ? price - discountedPrice : 0.0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      sku: json['sku'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage:json['discount_percentage'] != null
       ? (json['discount_percentage'] as num).toDouble()
       : null,
      containerType: json['container_type'] as String,
      productType: json['product_type'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'name': name,
      'price': price,
      'discount_percentage': discountPercentage,
      'container_type': containerType,
      'product_type': productType,
      'imageUrl': imageUrl,
    };
  }
}