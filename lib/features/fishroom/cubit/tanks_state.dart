part of 'tanks_cubit.dart';

class TanksState {
  final List<Tank> tanks;
  final bool error;

  const TanksState({
    required this.tanks,
    required this.error,
  });

  TanksState copyWith({
    List<Tank>? tanks,
    bool? error,
  }) {
    return TanksState(
      tanks: tanks ?? this.tanks,
      error: error ?? false,
    );
  }
}
