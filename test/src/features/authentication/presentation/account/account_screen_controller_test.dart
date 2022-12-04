import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// How to work with mocks
/// - create mock classes for any dependencies
/// - mock methods and properties will always return null
/// - use stub!

class MockAuthRepository extends Mock implements FakeAuthRepository {
  /// Mock objects implement all methods in the parent interface
  /// but they return null by default!
}

void main() {
  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      final authRepository = MockAuthRepository();
      final controller =
          AccountScreenController(authRepository: authRepository);

      verifyNever(authRepository.signOut);

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

    /// A 'mock' auth repository will let us:
    /// 1. decide if the signOut() method should succeed or throw an exception
    /// 2. check if signOut() is actually called

    test('signOut success', () async {
      final authRepository = MockAuthRepository();

      /// Method stub
      /// tells the mock what to return/throw when the method is called
      when(authRepository.signOut).thenAnswer((_) => Future.value());
      final controller =
          AccountScreenController(authRepository: authRepository);

      await controller.signOut();
      expect(controller.debugState, const AsyncData<void>(null));

      verify(authRepository.signOut).called(1);

      /// expect vs verify
      ///
      /// Given our controller(object uder test):
      /// - use expect() to check the output/state/return value
      /// - use verify() to check the behavior
    });

    test('signOut failure', () async {
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(authRepository.signOut).thenThrow(exception);

      final controller =
          AccountScreenController(authRepository: authRepository);

      await controller.signOut();

      expect(controller.debugState.hasError, true);

      /// isA<Type> is a generic type matcher
      /// useful to check if a value is of a certain type
      expect(controller.debugState, isA<AsyncError>());
      verify(authRepository.signOut).called(1);
    });
  });
}


/// Testing with Mocks
/// 
/// 1. Create a mock class for each dependency in our object under test
/// 2. Configure the mock by sutbbing all the methods that will be called (return, answer or throw)
/// 3. Call the method we want to test
/// 4. Verify the results(with verify and/or expect)