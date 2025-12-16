import 'package:bloc_hive_caching_data/features/home/data/model/hive_helper/fields/products_fields.dart';
import 'package:bloc_hive_caching_data/hive_helper/fields/products_model_fields.dart';
import 'package:bloc_hive_caching_data/hive_helper/hive_types.dart';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: HiveTypes.productsModel)
class ProductsModel extends HiveObject {
  @HiveField(ProductsModelFields.success)
  final bool success;
  @HiveField(ProductsModelFields.totalProducts)
  final int totalProducts;
  @HiveField(ProductsModelFields.message)
  final String message;
  @HiveField(ProductsModelFields.offset)
  final int offset;
  @HiveField(ProductsModelFields.limit)
  final int limit;
  @HiveField(ProductsModelFields.products)
  final List<Products> products;

  ProductsModel({
    required this.success,
    required this.totalProducts,
    required this.message,
    required this.offset,
    required this.limit,
    required this.products,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    success: json['success'],
    totalProducts: json['total_products'],
    message: json['message'],
    offset: json['offset'],
    limit: json['limit'],
    products: (json['products'] as List)
        .map((x) => Products.fromJson(x))
        .toList(),
  );
}

@HiveType(typeId: HiveTypes.products)
class Products extends HiveObject {
  @HiveField(ProductsFields.id)
  final int id;
  @HiveField(ProductsFields.price)
  final double price;
  @HiveField(ProductsFields.category)
  final String category;
  @HiveField(ProductsFields.updatedAt)
  final String updatedAt;
  @HiveField(ProductsFields.photoUrl)
  final String photoUrl;
  @HiveField(ProductsFields.name)
  final String name;
  @HiveField(ProductsFields.description)
  final String description;
  @HiveField(ProductsFields.createdAt)
  final String createdAt;

  Products({
    required this.id,
    required this.price,
    required this.category,
    required this.updatedAt,
    required this.photoUrl,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json['id'],
    price: json['price']?.toDouble(),
    category: json['category'].toString(),
    updatedAt: DateTime.parse(json['updated_at']).toString(),
    photoUrl: json['photo_url'],
    name: json['name'],
    description: json['description'],
    createdAt: DateTime.parse(json['created_at']).toString(),
  );
}
