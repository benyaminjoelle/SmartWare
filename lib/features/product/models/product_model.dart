class Product {
  final String sku;
  final String name;
  final double price;
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
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      sku: json['sku'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
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
      'container_type': containerType,
      'product_type': productType,
      'imageUrl': imageUrl,
    };
  }
}