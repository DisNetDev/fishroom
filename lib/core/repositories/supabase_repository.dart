import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  SupabaseRepository();

  final SupabaseClient supabase = Supabase.instance.client;
  User? user;
  Session? session;

  Future<void> signUpWithPassword(String email, String password) async {
    AuthResponse authResponse =
        await supabase.auth.signUp(email: email, password: password);
    if (authResponse.session == null) {
      throw Exception("Something went wrong");
    }
    user = authResponse.user;
    session = authResponse.session;
  }

  Future<void> signInWithPassword(String email, String password) async {
    AuthResponse authResponse = await supabase.auth
        .signInWithPassword(email: email, password: password);
    if (authResponse.session == null) {
      throw Exception("Something went wrong");
    }
    user = authResponse.user;
    session = authResponse.session;
  }
}
