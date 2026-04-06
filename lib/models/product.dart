class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stockQuantity;
  final String? imageUrl;
  final String manufacturer;
  final bool requiresPrescription;
  final String? pharmacyName;
  final int? pharmacyId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
    required this.manufacturer,
    required this.requiresPrescription,
    this.pharmacyName,
    this.pharmacyId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      stockQuantity: json['stock_quantity'] ?? 0,
      imageUrl: json['image_url'],
      manufacturer: json['manufacturer'] ?? '',
      requiresPrescription: json['requires_prescription'] ?? false,
      pharmacyName: json['pharmacy_name'],
      pharmacyId: json['pharmacy_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stock_quantity': stockQuantity,
      'image_url': imageUrl,
      'manufacturer': manufacturer,
      'requires_prescription': requiresPrescription,
      'pharmacy_name': pharmacyName,
      'pharmacy_id': pharmacyId,
    };
  }
}
