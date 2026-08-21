class CreateProductResponse {
  final String message;
  final CreatedProductModel data;

  CreateProductResponse({
    required this.message,
    required this.data,
  });

  factory CreateProductResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateProductResponse(
      message: json['message']?.toString() ?? '',
      data: CreatedProductModel.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class CreatedProductModel {
  final int id;
  final String sku;
  final String name;
  final String? unit;
  final String? productImage;
  final String? description;
  final List<dynamic> categories;

  CreatedProductModel({
    required this.id,
    required this.sku,
    required this.name,
    this.unit,
    this.productImage,
    this.description,
    required this.categories,
  });

  factory CreatedProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreatedProductModel(
      id: json['id'] ?? 0,
      sku: json['sku']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      unit: json['unit']?.toString(),
      productImage: json['product_image']?.toString(),
      description: json['description']?.toString(),
      categories: json['categories'] is List
          ? json['categories']
          : [],
    );
  }
}