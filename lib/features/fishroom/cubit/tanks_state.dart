part of 'tanks_cubit.dart';

class TanksState {
  final List<Tank> tanks;
  final List<TankReading> readings;
  final bool error;

  const TanksState({
    required this.tanks,
    required this.readings,
    required this.error,
  });

  TanksState copyWith({
    List<Tank>? tanks,
    List<TankReading>? readings,
    bool? error,
  }) {
    return TanksState(
      tanks: tanks ?? this.tanks,
      readings: readings ?? this.readings,
      error: error ?? false,
    );
  }
}
