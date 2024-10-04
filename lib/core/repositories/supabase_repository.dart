import 'dart:io';

import 'package:fishroom/core/usecases/log.dart';
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
    } on Exception catch (_) {
      rethrow;
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
    } on Exception catch (_) {
      rethrow;
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
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<PostgrestList?> fetchUser() async {
    if (user != null) {
      fishLog(user!.id, prefix: "UserID");
      final data =
          await supabase.from("users").select().eq("email", user!.email!);
      return data;
    }
    return null;
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

  Future<String?> uploadImage(File file) async {
    final String fileName = file.path.split('/').last;
    final String fullPath = await supabase.storage.from('tank_images').upload(
          '${user!.id}/$fileName',
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    return fullPath;
  }
}

class UserSession {
  final User? user;
  final Session? session;

  UserSession({required this.user, required this.session});
}
