import 'package:fishroom/features/settings/models/settings.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../core/models/database_tables.dart';
import '../../../core/repositories/supabase_repository.dart';
import '../../bug_report/models/bug_report.dart';
import '../../tank_reading/models/parameter.dart';
import '../models/fish_user.dart';
import '../models/login_event.dart';

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
              : Settings(parameters: [], fertilizers: []);

          emit(state.copyWith(user: user, settings: settings));
        }
      }
      emit(state);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logLoginEvent() async {
    try {
      await _supabaseRepository.insert(
          tableName: "login_events",
          json: LoginEvent(
                  uuid: state.user!.uuid, createdAt: DateTime.now().toString())
              .toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      return _supabaseRepository.checkIfEmailExists(email);
    } catch (e) {
      rethrow;
    }
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
          tableName: SupabaseTable.users.tableName,
          conditionalColumn: SupabaseTable.users.id,
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
          tableName: SupabaseTable.appDefaults.tableName,
          conditionalColumn: SupabaseTable.appDefaults.name,
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
            tableName: SupabaseTable.users.tableName,
            json: {SupabaseTable.users.settings: settings.toJson()},
            conditionalColumn: SupabaseTable.users.id,
            condition: uuid ?? state.user!.uuid);
      } catch (e) {
        emit(oldState);
        rethrow;
      }
    }
  }

  Future<void> upgradeUserToPro({bool isPro = true}) async {
    try {
      if (state.user != null) {
        await _supabaseRepository.update(
            tableName: SupabaseTable.users.tableName,
            json: {SupabaseTable.users.premium: isPro},
            conditionalColumn: SupabaseTable.users.id,
            condition: state.user!.uuid);
        emit(state.copyWith(user: state.user!.copyWith(premium: isPro)));
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> submitBugReport(BugReport bugReport) async {
    fishLog("Submitting bug report...");
    fishLog(bugReport.toJson().toString());
    try {
      await _supabaseRepository.insert(
          tableName: SupabaseTable.bugReports.tableName,
          json: bugReport.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      final data = await _supabaseRepository
          .runFunction("check_username_existence", {"p_username": username});
      fishLog("Username '$username' exists: ${data.toString()}");
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUsername(String username) async {
    try {
      await _supabaseRepository.update(
          tableName: SupabaseTable.users.tableName,
          json: {SupabaseTable.users.username: username},
          conditionalColumn: SupabaseTable.users.id,
          condition: state.user!.uuid);
      emit(state.copyWith(user: state.user!.copyWith(username: username)));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setWelcomeEmailSent(bool value) async {
    try {
      await _supabaseRepository.update(
          tableName: SupabaseTable.users.tableName,
          json: {"welcome_email_sent": value},
          conditionalColumn: SupabaseTable.users.id,
          condition: state.user!.uuid);
      emit(state.copyWith(user: state.user!.copyWith(welcomeEmailSent: value)));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkSub() async {
    final CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    final bool isPro = customerInfo.activeSubscriptions.isNotEmpty;

    if (isPro) {
      if (!state.user!.premium) {
        await upgradeUserToPro(isPro: true);
      }
    } else {
      if (state.user!.premium) {
        await upgradeUserToPro(isPro: false);
      }
    }
  }

  Future<void> getSubscriptions() async {
    final Offerings offerings = await Purchases.getOfferings();
    final List<Package> subscriptions =
        offerings.current?.availablePackages ?? [];
    emit(state.copyWith(availableSubscriptions: subscriptions));
  }
}
