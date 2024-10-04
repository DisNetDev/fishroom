import 'package:fishroom/core/usecases/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/repositories/supabase_repository.dart';
import '../models/fish_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._supabaseRepository) : super(AuthState());

  final SupabaseRepository _supabaseRepository;

  Future<void> signUpWithPassword(
      {required String email, required String password}) async {
    UserSession? userSession;
    try {
      userSession =
          await _supabaseRepository.signUpWithPassword(email, password);
      emit(state.copyWith(session: userSession.session));
    } catch (e) {
      emit(state.copyWith(error: true, errorMessage: e.toString()));
      rethrow;
    }
  }

  Future<void> signInWithPassword(
      {required String email, required String password}) async {
    fishLog("Signing in with password...");
    UserSession? userSession;
    FishUser? user;
    try {
      userSession =
          await _supabaseRepository.signInWithPassword(email, password);

      if (userSession.session != null) {
        fishLog("Getting User Data...");
        final data = await _supabaseRepository.fetchUser();
        if (data != null && data.isNotEmpty) {
          user = FishUser.fromJson(data.first);
          emit(state.copyWith(user: user));
        }
      }
      emit(state.copyWith(session: userSession.session));
    } catch (e) {
      emit(state.copyWith(error: true, errorMessage: e.toString()));

      rethrow;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    return _supabaseRepository.checkIfEmailExists(email);
  }

  void clear() {
    emit(AuthState());
  }
}
