import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Acceptance Criteria
/// (normally used to write 'user stories')
///
/// Given (how things begin)
/// When (action taken)
/// Then (outcome of taking action)
///

class MockAuthRepository extends Mock implements FakeAuthRepository {
  /// Mock objects implement all methods in the parent interface
  /// but they return null by default!
}

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';

  group('submit', () {
    test("""
Given formType is signIn
When singInWithEmailAndPassword succeeds
Then return true
And state is AsyncData
""", () async {
      final authRepository = MockAuthRepository();
      when(() =>
              authRepository.signInWithEmailAndPssword(testEmail, testPassword))
          .thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);

      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading<void>(),
          ),
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncData<void>(null),
          ),
        ]),
      );

      final result = await controller.submit(testEmail, testPassword);
      expect(result, true);
    }, timeout: const Timeout(Duration(microseconds: 500)));

    test("""
Given formType is signIn
When singInWithEmailAndPassword fails
Then return false
And state is AsyncError
""", () async {
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(() =>
              authRepository.signInWithEmailAndPssword(testEmail, testPassword))
          .thenThrow(exception);
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);

      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading<void>(),
          ),
          predicate<EmailPasswordSignInState>((state) {
            expect(state.formType, EmailPasswordSignInFormType.signIn);
            expect(state.value.hasError, true);
            return true;
          }),
        ]),
      );

      final result = await controller.submit(testEmail, testPassword);
      expect(result, false);
    }, timeout: const Timeout(Duration(microseconds: 500)));
  });

  group('updateFormType', () {});
}
