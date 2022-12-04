import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      final authRepository = FakeAuthRepository();
      final controller =
          AccountScreenController(authRepository: authRepository);

      /// When to use type annotations
      /// - when you declare something (class/ method/ property ..)
      /// - when dart can't infer the full type for us
      ///

      expect(controller.debugState, const AsyncData<void>(null));

      /// AsyncValue & friends
      /// AsyncValue.data -> AsyncData
      /// AsyncValue.loading -> AsyncLoading
      /// AsyncValue.error -> AsyncError
      ///
      /// All subclasses of AsyncValue
    });
  });
}
