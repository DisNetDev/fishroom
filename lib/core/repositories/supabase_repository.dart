import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      fishLog(user!.id, prefix: "UserID");
      final data =
          await supabase.from("users").select().eq("email", user!.email!);
      return data;
    } else {
      showToast(
          title: "Something went wrong.",
          description: "You are not signed in.");
      return null;
    }
  }

  Future<void> insert(
      {required String tableName, required Map<String, dynamic> json}) async {
    await supabase.from(tableName).insert(json);
  }

  Future<PostgrestList?> fetch(
      {required String tableName,
      required String column,
      required String condition}) async {
    final data = await supabase.from(tableName).select().eq(column, condition);
    return data;
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
