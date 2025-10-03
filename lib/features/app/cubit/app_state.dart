part of 'app_cubit.dart';

class AppState {
  final FishUser? user;
  final Settings settings;
  final bool appLoaded;
  final bool isOfflineMode;

  AppState({
    this.user,
    Settings? settings,
    this.appLoaded = false,
    this.isOfflineMode = false,
  }) : settings = settings ?? Settings(parameters: [], fertilizers: []);

  AppState copyWith({
    FishUser? user,
    Settings? settings,
    bool? appLoaded,
    bool? isOfflineMode,
  }) {
    return AppState(
      user: user ?? this.user,
      settings: settings ?? this.settings,
      appLoaded: appLoaded ?? this.appLoaded,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }
}
