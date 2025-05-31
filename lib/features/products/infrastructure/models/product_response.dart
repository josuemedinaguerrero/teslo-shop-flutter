import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class ProductResponse {
  final String id;
  final String title;
  final int price;
  final String description;
  final String slug;
  final int stock;
  final List<String> sizes;
  final String gender;
  final List<String> tags;
  final List<String> images;
  final User user;

  ProductResponse({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.slug,
    required this.stock,
    required this.sizes,
    required this.gender,
    required this.tags,
    required this.images,
    required this.user,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        slug: json["slug"],
        stock: json["stock"],
        sizes: List<String>.from(json["sizes"].map((x) => x)),
        gender: json["gender"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        images: List<String>.from(
          json["images"].map(
              (image) => image.toString().startsWith('http') ? image.toString() : '${Environment.apiUrl}/files/product/$image'),
        ),
        user: UserMapper.userJsonToEntity(json['user']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "slug": slug,
        "stock": stock,
        "sizes": List<String>.from(sizes.map((x) => x)),
        "gender": gender,
        "tags": List<String>.from(tags.map((x) => x)),
        "images": List<String>.from(images.map((x) => x)),
        "user": user.toString(),
      };
}
