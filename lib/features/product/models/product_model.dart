class Product {
  final int id;
  final String sku;
  final String name;
  final String unit;
  final String companyName;
  final List<String> categories;
  final String? imageUrl;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.unit,
    required this.companyName,
    required this.categories,
    this.imageUrl,
  });

 
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      sku: json['sku'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      companyName: json['company']['name'] as String,
      categories: (json['categories'] as List<dynamic>? ?? [])
        .map((category) => category['name'].toString())
        .toList(),
      imageUrl: json['product_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'unit': unit,
      'categories': categories,
      'product_image': imageUrl,
    };
  }
}