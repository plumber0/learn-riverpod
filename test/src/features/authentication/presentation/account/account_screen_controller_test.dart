@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

/// How to work with mocks
/// - create mock classes for any dependencies
/// - mock methods and properties will always return null
/// - use stub!

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;

  /// Are test lifecycle methods a good idea?
  ///
  /// - risk of introducing side effects where some objects or state are
  /// unintentionally shared across tests,
  /// leading to test failures that are hard to debug

  setUp(() {
    print('setup has called');
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });

  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
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

    test(
      'signOut success',
      () async {
        /// Method stub
        /// tells the mock what to return/throw when the method is called
        when(authRepository.signOut).thenAnswer((_) => Future.value());

        /// expectLater
        /// - same as expect, but returns a Future
        /// - emitsInOrder is an 'asynchronous matcher'
        /// - expectLater carries more meaning
        /// clear that we expect something to happen in the future,
        /// after signOut() has completed

        expectLater(
            controller.stream,
            emitsInOrder(const [
              AsyncLoading<void>(),
              AsyncData<void>(null),
            ]));
        await controller.signOut();

        verify(authRepository.signOut).called(1);

        /// expect vs verify
        ///
        /// Given our controller(object uder test):
        /// - use expect() to check the output/state/return value
        /// - use verify() to check the behavior
      },
      // a shorter test timeout guarantees that when our tests hang, they fail quickly
      // Running hundreds/thousands of tests on CI can be expensive,
      // so we want them fast even when they fail
    );

    test(
      'signOut failure',
      () async {
        final exception = Exception('Connection failed');
        when(authRepository.signOut).thenThrow(exception);

        expectLater(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              // Predicates give us fine grained control over the values we want to test
              predicate<AsyncValue<void>>((value) {
                expect(value.hasError, true);
                return true;
              }),
            ]));

        await controller.signOut();

        /// isA<Type> is a generic type matcher
        /// useful to check if a value is of a certain type
        expect(controller.debugState, isA<AsyncError>());
        verify(authRepository.signOut).called(1);
      },
    );
  });
}

/// Testing with Mocks
///
/// 1. Create a mock class for each dependency in our object under test
/// 2. Configure the mock by sutbbing all the methods that will be called (return, answer or throw)
/// 3. Call the method we want to test
/// 4. Verify the results(with verify and/or expect)
