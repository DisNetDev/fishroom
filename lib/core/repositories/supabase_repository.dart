import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/models/fish_user.dart';

class SupabaseRepository {
  SupabaseRepository();

  final SupabaseClient supabase = Supabase.instance.client;
  User? user;
  Session? session;

  Future<UserSession> signUpWithPassword(String email, String password) async {
    try {
      AuthResponse authResponse =
          await supabase.auth.signUp(email: email, password: password);
      if (authResponse.session == null) {
        throw Exception("Something went wrong signing up");
      }
      user = authResponse.user;
      session = authResponse.session;
      return UserSession(user: user, session: session);
    } on Exception catch (e) {
      _handleException(e);
      return UserSession(user: null, session: null);
    }
  }

  Future<UserSession> signInWithPassword(String email, String password) async {
    try {
      AuthResponse authResponse = await supabase.auth
          .signInWithPassword(email: email, password: password);
      if (authResponse.session == null) {
        throw Exception("Something went wrong signing in");
      }
      user = authResponse.user;
      session = authResponse.session;
      return UserSession(user: user, session: session);
    } on Exception catch (e) {
      _handleException(e);
      return UserSession(user: null, session: null);
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      final data =
          await supabase.from("users_check").select("email").eq("email", email);
      final List<Map<String, dynamic>> decodedData = data;
      if (decodedData.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      _handleException(e);
      return false;
    }
  }

  Future<PostgrestList?> fetchUser() async {
    if (user != null) {
      final data =
          await supabase.from("users").select("email").eq("id", user!.id);
      return data;
    } else {
      showToast(
          title: "Something went wrong.",
          description: "You are not signed in.");
      return null;
    }
  }
}

class UserSession {
  final User? user;
  final Session? session;

  UserSession({required this.user, required this.session});
}

_handleException(e) {
  showToast(title: "Something went wrong.", description: e.toString());
}
