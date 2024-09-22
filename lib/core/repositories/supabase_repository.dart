import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  SupabaseRepository();

  final SupabaseClient supabase = Supabase.instance.client;
  User? user;
  Session? session;

  Future<UserSession> signUpWithPassword(String email, String password) async {
    AuthResponse authResponse =
        await supabase.auth.signUp(email: email, password: password);
    if (authResponse.session == null) {
      throw Exception("Something went wrong signing up");
    }
    user = authResponse.user;
    session = authResponse.session;
    return UserSession(user: user, session: session);
  }

  Future<UserSession> signInWithPassword(String email, String password) async {
    AuthResponse authResponse = await supabase.auth
        .signInWithPassword(email: email, password: password);
    if (authResponse.session == null) {
      throw Exception("Something went wrong signing in");
    }
    user = authResponse.user;
    session = authResponse.session;
    return UserSession(user: user, session: session);
  }
}

class UserSession {
  final User? user;
  final Session? session;

  UserSession({required this.user, required this.session});
}
