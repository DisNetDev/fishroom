import 'dart:math' as math;
import '../models/units.dart';

class CO2Service {
  // Widely used approximation: CO2 (ppm) = 3 * KH(dKH) * 10^(7 - pH)
  static double co2PpmFromKhPh(
      {required double khValue, required KHUnit khUnit, required double pH}) {
    final khDkh =
        khUnit == KHUnit.dKH ? khValue : UnitConverter.meqLToDkh(khValue);
    final factor = math.pow(10, 7 - pH) as double;
    return 3.0 * khDkh * factor;
  }

  // Inverse: Given target CO2 and KH, suggest pH to hit that CO2
  static double pHFromCo2Kh(
      {required double targetCo2Ppm,
      required double khValue,
      required KHUnit khUnit}) {
    final khDkh =
        khUnit == KHUnit.dKH ? khValue : UnitConverter.meqLToDkh(khValue);
    if (khDkh <= 0) return double.nan;
    final ratio = targetCo2Ppm / (3.0 * khDkh);
    log10(num x) => math.log(x) / math.ln10;
    return 7 - log10(ratio);
  }

  // Heuristic bubble-rate estimator. Highly approximate; depends on method efficiency.
  // Returns bubbles per second (bps).
  static double estimateBps({
    required double tankVolume,
    required VolumeUnit volumeUnit,
    required double targetCo2Ppm,
    required DiffusionMethod method,
  }) {
    final liters = switch (volumeUnit) {
      VolumeUnit.liters => tankVolume,
      VolumeUnit.gallonsUS => UnitConverter.gallonsUSToLiters(tankVolume),
      VolumeUnit.gallonsImperial =>
        UnitConverter.gallonsImperialToLiters(tankVolume),
    };

    // Approximate efficiency multipliers (lower = more efficient, fewer bubbles needed)
    final efficiency = switch (method) {
      DiffusionMethod.reactor => 0.6,
      DiffusionMethod.inline => 0.7,
      DiffusionMethod.diffuser => 1.0,
      DiffusionMethod.airstone => 1.4,
    };

    // Baseline: ~1 bps per 100 L to maintain ~20-30 ppm on typical planted tanks.
    // Scale with target ppm and efficiency.
    final baselineBps = liters / 100.0;
    final bps = baselineBps * (targetCo2Ppm / 25.0) * efficiency;
    return bps.clamp(0.0, double.infinity);
  }
}
