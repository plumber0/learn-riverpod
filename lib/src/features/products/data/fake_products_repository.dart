import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _getProduct(_products, id);
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  // ref can be used to access other providers as dependencies
  return FakeProductsRepository();
});

// one method one provider
final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  debugPrint('created productsListStreamProvider');
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});

// one method one provider
final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductsList();
});

// one method one provider
final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  debugPrint('created productProvider with id: $id');
  ref.onDispose(() => debugPrint('disposed productProvider'));
  //data cache
  // KeepAliveLink + Timer allows us to implement a 'cache with timeout' policy
  final link = ref.keepAlive();
  Timer(const Duration(seconds: 10), () {
    link.close();
  });
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
});

/// how autoDispose work
/// When we 'watch' a provider inside a widget,
/// the widget is added as a listner, so that is rebuilds if the provider value changes
/// when a widget is unmonted (ex. on back navigation), the listner is removed
/// when the last listener is removed, the provider is disposed (if we're using .autoDispose)
/// (similar behavior to StreamBuilder and FutureBuilder)
///
/// provider has their onw life cycle just like widget do
///
///
/// when should you use autoDispose?
///
/// - StreamProvider? Yes
/// This whill ensure your stream connection is closed when you no longer need it
/// - FutureProvider? also Yes
