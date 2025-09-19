enum KHUnit { dKH, meqL }

enum VolumeUnit { liters, gallonsUS, gallonsImperial }

enum DiffusionMethod { diffuser, reactor, inline, airstone }

class UnitConverter {
  static const double dKHPerMeqL = 2.8; // 1 meq/L = 2.8 dKH (approx)
  static const double litersPerGallonUS = 3.785411784;
  static const double litersPerGallonImperial = 4.54609;

  static double dkhToMeqL(double dkh) => dkh / dKHPerMeqL;
  static double meqLToDkh(double meqL) => meqL * dKHPerMeqL;

  static double litersToGallonsUS(double liters) => liters / litersPerGallonUS;
  static double gallonsUSToLiters(double gallons) =>
      gallons * litersPerGallonUS;
  static double litersToGallonsImperial(double liters) =>
      liters / litersPerGallonImperial;
  static double gallonsImperialToLiters(double gallons) =>
      gallons * litersPerGallonImperial;
}
