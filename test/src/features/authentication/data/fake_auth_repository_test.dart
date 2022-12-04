import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  final testUser =
      AppUser(uid: testEmail.split('').reversed.join(), email: testEmail);

  FakeAuthRepository makeAuthRepository() =>
      FakeAuthRepository(addDelay: false);
  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      final authRepository = makeAuthRepository();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('currentUser is not null after sign in', () async {
      final authRepository = makeAuthRepository();
      await authRepository.signInWithEmailAndPssword(testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is not null after registration', () async {
      final authRepository = makeAuthRepository();
      await authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is null after sign out (1)', () async {
      final authRepository = makeAuthRepository();

      /// it is possible to check the various values
      /// that are added to the stream
      ///
      /// Streams emit values over time
      /// We can only check stream values
      /// if we observe them over time
      expect(authRepository.authStateChanges(),
          emitsInOrder([null, testUser, null]));

      await authRepository.signInWithEmailAndPssword(testEmail, testPassword);
      await authRepository.signOut();
      expect(authRepository.currentUser, null);
    });

    test('currentUser is null after sign out (2)', () async {
      /// above test is not intuitive

      final authRepository = makeAuthRepository();

      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));

      await authRepository.signInWithEmailAndPssword(testEmail, testPassword);

      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));

      await authRepository.signOut();

      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('sigin in after dispose thorws exeptions', () {
      final authRepository = makeAuthRepository();
      authRepository.dispose();
      expect(
        () => authRepository.signInWithEmailAndPssword(testEmail, testPassword),
        throwsStateError,
      );
    });
  });
}
