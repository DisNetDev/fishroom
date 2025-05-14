part of 'app_cubit.dart';

class AppState {
  final FishUser? user;
  final Settings settings;
  final bool appLoaded;
  final List<Package> availableSubscriptions;

  AppState({
    this.user,
    Settings? settings,
    List<Package>? availableSubscriptions,
    this.appLoaded = false,
  })  : settings = settings ?? Settings(parameters: [], fertilizers: []),
        availableSubscriptions = availableSubscriptions ?? [];

  AppState copyWith({
    FishUser? user,
    Settings? settings,
    bool? appLoaded,
    List<Package>? availableSubscriptions,
  }) {
    return AppState(
      user: user ?? this.user,
      settings: settings ?? this.settings,
      appLoaded: appLoaded ?? this.appLoaded,
      availableSubscriptions:
          availableSubscriptions ?? this.availableSubscriptions,
    );
  }
}
