import 'package:fishroom/features/settings/models/settings.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../core/models/database_tables.dart';
import '../../../core/repositories/supabase_repository.dart';
import '../../tank_reading/models/parameter.dart';
import '../models/fish_user.dart';

part 'app_state.dart';

class AppCubit extends HydratedCubit<AppState> {
  AppCubit(this._supabaseRepository) : super(AppState());

  final SupabaseRepository _supabaseRepository;

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState(
      user: json['user'] != null ? FishUser.fromJson(json['user']) : null,
      settings:
          json['settings'] != null ? Settings.fromJson(json['settings']) : null,
      appLoaded: false,
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'user': state.user?.toJson(),
      'settings': state.settings.toJson(),
      'appLoaded': false,
    };
  }

  void setAppLoaded(bool set) {
    emit(state.copyWith(appLoaded: set));
  }

  void debugToggleFreeAndPro() {
    if (state.user != null) {
      emit(state.copyWith(
          user: state.user!.copyWith(premium: !state.user!.premium)));
    }
  }

  Future<void> signUpWithPassword(
      {required String email, required String password}) async {
    try {
      await _supabaseRepository.signUpWithPassword(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithPassword(
      {required String email, required String password}) async {
    fishLog("Signing in with password...");
    UserSession? userSession;
    FishUser? user;
    Settings? settings;

    try {
      userSession =
          await _supabaseRepository.signInWithPassword(email, password);

      if (userSession.session != null) {
        fishLog("Getting User Data...");
        var data = await _supabaseRepository.fetchUser();
        if (data != null && data.isNotEmpty) {
          if (data.first["settings"] == null) {
            List<Parameter> parameters = await setParametersDefaults();
            await updateSettings(
              state.settings.copyWith(parameters: parameters),
              uuid: data.first["id"],
            );
            data = await _supabaseRepository.fetchUser();
          }
        }
        if (data != null && data.isNotEmpty) {
          user = FishUser.fromJson(data.first);
          settings = Settings.fromJson(data.first["settings"]);

          emit(state.copyWith(user: user, settings: settings));
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> nativeGoogleSignIn() async {
    fishLog("Signing in with Google...");
    UserSession? userSession;
    FishUser? user;
    Settings? settings;

    try {
      userSession = await _supabaseRepository.nativeGoogleSignIn();

      if (userSession.session != null) {
        fishLog("Getting User Data...");
        var data = await _supabaseRepository.fetchUser();
        if (data != null && data.isNotEmpty) {
          if (data.first["settings"] == null) {
            List<Parameter> parameters = await setParametersDefaults();
            await updateSettings(
              state.settings.copyWith(parameters: parameters),
              uuid: data.first["id"],
            );
            data = await _supabaseRepository.fetchUser();
          }
        }
        if (data != null && data.isNotEmpty) {
          user = FishUser.fromJson(data.first);
          settings = data.first["settings"] != null
              ? Settings.fromJson(data.first["settings"])
              : Settings(parameters: []);

          emit(state.copyWith(user: user, settings: settings));
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
    emit(AppState());
  }

  Future<void> fetchUser() async {
    FishUser? user;
    Settings? settings;
    try {
      fishLog("Getting User Data...");
      final data = await _supabaseRepository.fetchUser();
      if (data != null && data.isNotEmpty) {
        user = FishUser.fromJson(data.first);
        settings = Settings.fromJson(data.first["settings"]);

        emit(state.copyWith(user: user, settings: settings));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchSettings() async {
    try {
      fishLog("Getting Settings...");

      final data = await _supabaseRepository.fetch(
          tableName: Table.users.tableName,
          conditionalColumn: Table.users.id,
          condition: state.user!.uuid);
      if (data != null && data.isNotEmpty) {
        emit(state.copyWith(
            settings: Settings.fromJson(data.first["settings"])));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Parameter>> setParametersDefaults() async {
    fishLog("Resetting parameters...");
    try {
      final data = await _supabaseRepository.fetch(
          tableName: Table.appDefaults.tableName,
          conditionalColumn: Table.appDefaults.name,
          condition: "default_params");
      if (data != null && data.isNotEmpty) {
        List<Parameter> parameters = [];
        for (Map<String, dynamic> param in data.first["value"]) {
          parameters.add(Parameter.fromJson(param));
        }
        fishLog("${parameters.length.toString()} parameters found.");

        return parameters;
      }

      return [];
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateSettings(Settings settings, {String? uuid}) async {
    fishLog("Updating settings...");
    AppState oldState = state;

    emit(state.copyWith(settings: settings));

    if (state.user != null || uuid != null) {
      try {
        await _supabaseRepository.update(
            tableName: Table.users.tableName,
            json: {Table.users.settings: settings.toJson()},
            conditionalColumn: Table.users.id,
            condition: uuid ?? state.user!.uuid);
      } catch (e) {
        emit(oldState);
        rethrow;
      }
    }
  }

  Future<void> upgradeUserToPro() async {
    try {
      if (state.user != null) {
        _supabaseRepository.update(
            tableName: Table.users.tableName,
            json: {Table.users.premium: true},
            conditionalColumn: id,
            condition: state.user!.uuid);
        emit(state.copyWith(user: state.user!.copyWith(premium: true)));
      }
    } on Exception catch (_) {
      rethrow;
    }
  }
}
