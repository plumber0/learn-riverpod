import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_user.dart';

/// How to create classes in the data layer:
/// 1. Design the API (public interface)
/// 2. Implement it

class FakeAuthRepository {
  Stream<AppUser?> authStateChanges() => Stream.value(null);

  AppUser? get currentUser => null;

  Future<void> signInWithEmailAndPssword(String email, String password) async {}

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {}

  Future<void> signOut() async {}
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  return FakeAuthRepository();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
