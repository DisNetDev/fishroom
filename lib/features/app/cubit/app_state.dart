part of 'app_cubit.dart';

class AppState {
  final FishUser? user;
  final Settings settings;

  AppState({
    this.user,
    Settings? settings,
  }) : settings = settings ?? Settings(parameters: []);

  AppState copyWith({
    FishUser? user,
    Settings? settings,
  }) {
    return AppState(
      user: user ?? this.user,
      settings: settings ?? this.settings,
    );
  }
}
