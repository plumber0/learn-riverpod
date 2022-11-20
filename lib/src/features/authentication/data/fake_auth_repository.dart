import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<void> signInWithEmailAndPssword(String email, String password);

  Future<void> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class FireBaseAuthRepository implements AuthRepository {
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

  void dispose() {}
}

/// How to create classes in the data layer:
/// 1. Design the API (public interface)
/// 2. Implement it

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> signInWithEmailAndPssword(String email, String password) async {
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 3));
    throw Exception('Connection failed');
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }
}

/// FakeAuthRepoistory <-> AuthRepository can switch between two
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  /// To use this, run the app with:
  /// --dart-define=useFakeRepos=true
  const isFake = String.fromEnvironment('useFakeRepos') == 'true';
  if (isFake) {
    final auth = FakeAuthRepository();
    ref.onDispose(() => auth.dispose());
    return auth;
  } else {
    final auth = FireBaseAuthRepository();
    ref.onDispose(() => auth.dispose());
    return auth;
  }
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
