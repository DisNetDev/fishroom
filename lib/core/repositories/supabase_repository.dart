import 'dart:io';

import 'package:fishroom/core/usecases/log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class SupabaseRepository {
  SupabaseRepository();

  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  User? user;
  Session? session;

  Future<T> _retryOperation<T>(Future<T> Function() operation) async {
    int retryCount = 0;
    while (true) {
      try {
        return await operation();
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          rethrow;
        }
        fishLog('Retry attempt $retryCount after error: $e');
        await Future.delayed(retryDelay * retryCount);
      }
    }
  }

  setSession() {
    session = supabase.auth.currentSession;
    user = supabase.auth.currentUser;
  }

  Future<UserSession> signUpWithPassword(String email, String password) async {
    return _retryOperation(() async {
      AuthResponse authResponse =
          await supabase.auth.signUp(email: email, password: password);
      if (authResponse.session == null) {
        throw Exception("Something went wrong signing up");
      }
      user = authResponse.user;
      session = authResponse.session;

      return UserSession(user: user, session: session);
    });
  }

  Future<UserSession> signInWithPassword(String email, String password) async {
    return _retryOperation(() async {
      AuthResponse authResponse = await supabase.auth
          .signInWithPassword(email: email, password: password);
      if (authResponse.session == null) {
        throw Exception("Something went wrong signing in");
      }
      user = authResponse.user;
      session = authResponse.session;

      return UserSession(user: user, session: session);
    });
  }

  Future<bool> checkIfEmailExists(String email) async {
    return _retryOperation(() async {
      final data =
          await supabase.from("users_check").select("email").eq("email", email);
      final List<Map<String, dynamic>> decodedData = data;

      return decodedData.isNotEmpty;
    });
  }

  Future<PostgrestList?> fetchUser() async {
    return _retryOperation(() async {
      if (user != null) {
        fishLog(user!.id, prefix: "UserID");

        return await supabase.from("users").select().eq("email", user!.email!);
      }

      return null;
    });
  }

  Future<void> insert(
      {required String tableName, required Map<String, dynamic> json}) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      await _retryOperation(() => supabase.from(tableName).insert(json));
      stopwatch.stop();
      fishLog("Insert took ${stopwatch.elapsedMilliseconds}ms");
    } catch (e) {
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
      final data = await _retryOperation(
          () => supabase.from(tableName).select().eq(column, condition));
      stopwatch.stop();
      fishLog("Fetch took ${stopwatch.elapsedMilliseconds}ms");

      return data;
    } catch (e) {
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
      await _retryOperation(
          () => supabase.from(tableName).update(json).eq(column, condition));
      stopwatch.stop();
      fishLog("Update took ${stopwatch.elapsedMilliseconds}ms");
    } catch (e) {
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
      await _retryOperation(
          () => supabase.from(tableName).delete().eq(column, condition));
      stopwatch.stop();
      fishLog("Delete took ${stopwatch.elapsedMilliseconds}ms");
    } catch (e) {
      stopwatch.stop();
      rethrow;
    }
  }

  Future<String?> uploadImage(File file) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      return await _retryOperation(() async {
        final String fileName = file.path.split('/').last;
        await supabase.storage.from('tank_images').upload(
              '${user!.id}/$fileName',
              file,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false),
            );

        final String url = supabase.storage
            .from('tank_images')
            .getPublicUrl('${user!.id}/$fileName');
        stopwatch.stop();
        fishLog("Upload took ${stopwatch.elapsedMilliseconds}ms");

        return url;
      });
    } catch (e) {
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
