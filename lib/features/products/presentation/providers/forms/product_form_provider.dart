import 'dart:developer';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>(
  (ref, arg) {
    final createUpdateCallback = ref.watch(productsProvider.notifier).createOrUpdateProduct;
    // final createUpdateCallback = ref.watch(productsRepositoryProvider).createUpdateProduct;
    return ProductFormNotifier(product: arg, onSubmitCallback: createUpdateCallback);
  },
);

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike) onSubmitCallback;

  ProductFormNotifier({required this.onSubmitCallback, required Product product})
      : super(ProductFormState(
          id: product.id,
          title: Title.dirty(value: product.title),
          slug: Slug.dirty(value: product.slug),
          price: Price.dirty(value: product.price),
          inStock: Stock.dirty(value: product.stock),
          sizes: product.sizes,
          gender: product.gender,
          description: product.description,
          tags: product.tags.join(", "),
          images: product.images,
        ));

  Future<bool> onFormSubmit() async {
    try {
      _touchedEverything();

      if (!state.isFormValid) return false;

      final productLike = {
        'id': state.id,
        'title': state.title.value,
        'price': state.price.value,
        'description': state.description,
        'slug': state.slug.value,
        'stock': state.inStock.value,
        'sizes': state.sizes,
        'gender': state.gender,
        'tags': state.tags.split(','),
        'images':
            state.images.map((image) => image.replaceAll('${Environment.apiUrl}/files/product', '').replaceAll("/", '')).toList(),
      };

      log('PRODUCT: $productLike');

      return await onSubmitCallback(productLike);
    } catch (e) {
      log('ERROR ON FORM SUBMIT: $e');
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(value: state.title.value),
        Slug.dirty(value: state.slug.value),
        Price.dirty(value: state.price.value),
        Stock.dirty(value: state.inStock.value)
      ]),
    );
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: Title.dirty(value: value),
      isFormValid: Formz.validate(
        [
          Title.dirty(value: value),
          Slug.dirty(value: state.slug.value),
          Price.dirty(value: state.price.value),
          Stock.dirty(value: state.inStock.value)
        ],
      ),
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value: value),
      isFormValid: Formz.validate(
        [
          Slug.dirty(value: value),
          Title.dirty(value: state.title.value),
          Price.dirty(value: state.price.value),
          Stock.dirty(value: state.inStock.value)
        ],
      ),
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value: value),
      isFormValid: Formz.validate(
        [
          Price.dirty(value: value),
          Slug.dirty(value: state.slug.value),
          Title.dirty(value: state.title.value),
          Stock.dirty(value: state.inStock.value)
        ],
      ),
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      inStock: Stock.dirty(value: value),
      isFormValid: Formz.validate(
        [
          Stock.dirty(value: value),
          Slug.dirty(value: state.slug.value),
          Title.dirty(value: state.title.value),
          Price.dirty(value: state.price.value)
        ],
      ),
    );
  }

  void onSizeChanged(List<String> sizes) => state = state.copyWith(sizes: sizes);

  void onGenderChanged(String gender) => state = state.copyWith(gender: gender);

  void onDescriptionChanged(String description) => state = state.copyWith(description: description);

  void onTagsChanged(String tags) => state = state.copyWith(tags: tags);
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.id,
    this.isFormValid = false,
    this.title = const Title.pure(),
    this.slug = const Slug.pure(),
    this.price = const Price.pure(),
    this.sizes = const [],
    this.gender = 'men',
    this.inStock = const Stock.pure(),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
