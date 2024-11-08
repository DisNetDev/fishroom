import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../core/models/database_tables.dart';
import '../../../core/repositories/supabase_repository.dart';
import '../models/fish_user.dart';

part 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit(this._supabaseRepository) : super(AuthState());

  final SupabaseRepository _supabaseRepository;

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState(
      user: json['user'] != null ? FishUser.fromJson(json['user']) : null,
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {
      'user': state.user?.toJson(),
    };
  }

  Future<void> signUpWithPassword(
      {required String email, required String password}) async {
    try {
      await _supabaseRepository.signUpWithPassword(email, password);
      emit(state);
    } catch (e) {
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
      emit(state);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    return _supabaseRepository.checkIfEmailExists(email);
  }

  void clearCubit() {
    emit(AuthState());
  }

  Future<void> fetchUser() async {
    FishUser? user;
    try {
      fishLog("Getting User Data...");
      final data = await _supabaseRepository.fetchUser();
      if (data != null && data.isNotEmpty) {
        user = FishUser.fromJson(data.first);
        emit(state.copyWith(user: user));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> upgradeUserToPro() async {
    if (state.user != null) {
      _supabaseRepository.update(
          tableName: Table.users.label,
          json: {"premium": true},
          column: "premium",
          condition: state.user!.uuid);
    }
  }
}
