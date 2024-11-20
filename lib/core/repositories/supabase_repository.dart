import 'dart:io';

import 'package:fishroom/core/usecases/log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class SupabaseRepository {
  SupabaseRepository();

  User? user;
  Session? session;

  setSession() {
    session = supabase.auth.currentSession;
    user = supabase.auth.currentUser;
  }

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
    try {
      if (user != null) {
        fishLog(user!.id, prefix: "UserID");
        final data =
            await supabase.from("users").select().eq("email", user!.email!);
        return data;
      }
      return null;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> insert(
      {required String tableName, required Map<String, dynamic> json}) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      await supabase.from(tableName).insert(json);
      stopwatch.stop();
      fishLog("Insert took ${stopwatch.elapsedMilliseconds}ms");
    } on Exception catch (_) {
      stopwatch.stop();
      rethrow;
    }
  }

  Future<PostgrestList?> fetch(
      {required String tableName,
      required String column,
      required String condition}) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      final data =
          await supabase.from(tableName).select().eq(column, condition);
      stopwatch.stop();
      fishLog("Fetch took ${stopwatch.elapsedMilliseconds}ms");

      return data;
    } on Exception catch (_) {
      stopwatch.stop();
      rethrow;
    }
  }

  Future<void> update(
      {required String tableName,
      required Map<String, dynamic> json,
      required String column,
      required String condition}) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      await supabase.from(tableName).update(json).eq(column, condition);
      stopwatch.stop();

      fishLog("Update took ${stopwatch.elapsedMilliseconds}ms");
    } on Exception catch (_) {
      stopwatch.stop();

      rethrow;
    }
  }

  Future<void> delete(
      {required String tableName,
      required String column,
      required String condition}) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      await supabase.from(tableName).delete().eq(column, condition);
      stopwatch.stop();

      fishLog("Insert took ${stopwatch.elapsedMilliseconds}ms");
    } on Exception catch (_) {
      stopwatch.stop();

      rethrow;
    }
  }

  Future<String?> uploadImage(File file) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      final String fileName = file.path.split('/').last;
      await supabase.storage.from('tank_images').upload(
            '${user!.id}/$fileName',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String url = supabase.storage
          .from('tank_images')
          .getPublicUrl('${user!.id}/$fileName');
      stopwatch.stop();
      fishLog("Upload took ${stopwatch.elapsedMilliseconds}ms");
      return url;
    } on Exception catch (_) {
      stopwatch.stop();

      rethrow;
    }
  }
}

class UserSession {
  final User? user;
  final Session? session;

  UserSession({required this.user, required this.session});
}
