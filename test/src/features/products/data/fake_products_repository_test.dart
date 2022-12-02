import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getProductsList returns global list', () {
    final productRepository = FakeProductsRepository();
    // The expect fuinction will call toString() on the expected
    // and actual values when reporting a test failure
    expect(
      productRepository.getProductsList(),
      kTestProducts,
    );
  });

  test('getProduict(1) returns first item', () {
    final productRepository = FakeProductsRepository();
    expect(
      productRepository.getProduct('1'),
      kTestProducts[0],
    );
  });
}
