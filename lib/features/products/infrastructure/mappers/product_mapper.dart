import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

class ProductMapper {
  static Product productResponseToEntity(ProductResponse productResponse) => Product(
        id: productResponse.id,
        title: productResponse.title,
        price: productResponse.price,
        description: productResponse.description,
        slug: productResponse.slug,
        stock: productResponse.stock,
        sizes: productResponse.sizes,
        gender: productResponse.gender,
        tags: productResponse.tags,
        images: productResponse.images,
        user: productResponse.user,
      );
}
