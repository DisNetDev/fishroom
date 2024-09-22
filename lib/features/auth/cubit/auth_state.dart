part of 'auth_cubit.dart';

class AuthState {
  final Session? session;
  final User? user;
  final bool error;
  final String errorMessage;

  AuthState({
    this.session,
    this.user,
    this.error = false,
    this.errorMessage = "",
  });

  AuthState copyWith({
    Session? session,
    User? user,
    bool? error,
    String? errorMessage,
  }) {
    return AuthState(
      session: session ?? this.session,
      user: user ?? this.user,
      error: error ?? false,
      errorMessage: errorMessage ?? "",
    );
  }
}
