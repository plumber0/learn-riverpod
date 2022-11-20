import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// StateNotifier is an alternative to ValueNotifier in the Flutter SDK
/// Ideal for managing immutable state that widgets can listen to
///
/// StateNotifier is a great place to write widget-specific business login
///
/// Rather than using state variables + setState() in your widget,
/// consider using a StateNotifier to control the state,
/// and 'watch' it in the widget.
///
/// Controllers are easy to test (with unit tests),
/// because they don't depend on the UI

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  /// AsyncValue.data needs a type
  /// We can use <void> and (null) if we have "no value"
  /// For our purposes, AsyncValue.data(null) means "not loading"
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue<void>.data(null));
  final AuthRepository authRepository;

  Future<bool> signOut() async {
    /// set state to loading
    /// sign out (using auth repository)
    /// if success, set state to data
    /// if error, set state to error

    try {
      state = const AsyncValue<void>.loading();
      await authRepository.signOut();
      state = const AsyncValue<void>.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue<void>.error(e, st);
      return false;
    }

    /// we're setting the state multiple times
    /// By 'watching' this StateNotifier in the build() method,
    /// our widget will rebuild every time the state changes
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepository);
});
