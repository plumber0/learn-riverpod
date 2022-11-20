import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> signInWithEmailAndPssword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class FireBaseAuthRepository implements AuthRepository{
  @override
  Stream<AppUser?> authStateChanges() {
    // TODO: implement authStateChanges
    throw UnimplementedError();
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AppUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> signInWithEmailAndPssword(String email, String password) {
    // TODO: implement signInWithEmailAndPssword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
  
}


/// How to create classes in the data layer:
/// 1. Design the API (public interface)
/// 2. Implement it

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> authStateChanges() => Stream.value(null);

  @override
  AppUser? get currentUser => null;

  @override
  Future<void> signInWithEmailAndPssword(String email, String password) async {}

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {}

  @override
  Future<void> signOut() async {}
}

/// FakeAuthRepoistory <-> AuthRepository can switch between two
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  /// To use this, run the app with:
  /// --dart-define=useFakeRepos=true
  final isFake = String.fromEnvironment('userFakeRepos') == 'true';
  return isFake? FakeAuthRepository() : FireBaseAuthRepository();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
