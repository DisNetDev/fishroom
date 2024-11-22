part of 'app_cubit.dart';

class AuthState {
  final FishUser? user;

  AuthState({
    this.user,
  });

  AuthState copyWith({
    FishUser? user,
  }) {
    return AuthState(
      user: user ?? this.user,
    );
  }
}
