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

  Map<String, dynamic> toJson() {
    return {
      'tanks': tanks.map((tank) => tank.toJson()).toList(),
      // 'readings': readings.map((reading) => reading.toJson()).toList(),
      'error': error,
    };
  }

  factory TanksState.fromJson(Map<String, dynamic> json) {
    return TanksState(
      tanks: (json['tanks'] as List<dynamic>)
          .map((item) => Tank.fromJson(item))
          .toList(),
      readings: [],
      // readings: (json['readings'] as List<dynamic>)
      //     .map((item) => TankReading.fromJson(item))
      //     .toList(),
      error: json['error'] as bool,
    );
  }
}
