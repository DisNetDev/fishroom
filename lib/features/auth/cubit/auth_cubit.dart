import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/repositories/supabase_repository.dart';

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
      emit(
          state.copyWith(session: userSession.session, user: userSession.user));
    } catch (e) {
      emit(state.copyWith(error: true, errorMessage: e.toString()));
      rethrow;
    }
  }
}
