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

  test('getProduct(100) return null', () {
    /// getProduct('100') is called immediately,
    /// This makes the test fail right away (unhandled exception)
    ///
    ///
    /// Solution : put the method into a closure
    ///
    /// if you need to test a function that throws, put it inside a closure
    /// This will ensure it is called lazily by the expect method
    /// (which will catch the exception)

    // expect(productsRepository.getProduct('100'), throwsStateError);

    // expect(
    //   () => productsRepository.getProduct('100'),
    //   throwsStateError,
    // );

    final productsRepository = FakeProductsRepository();
    expect(
      productsRepository.getProduct('100'),
      null,
    );
  });
}
