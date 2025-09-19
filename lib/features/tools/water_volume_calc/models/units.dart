enum LengthUnit { centimeters, inches, feet }

enum VolumeUnit { liters, gallonsUS, gallonsImperial }

enum TankShape { rectangular, cylindrical }

class UnitConverter {
  static double toCentimeters(double value, LengthUnit unit) {
    switch (unit) {
      case LengthUnit.centimeters:
        return value;
      case LengthUnit.inches:
        return value * 2.54;
      case LengthUnit.feet:
        return value * 30.48;
    }
  }

  static double fromCentimeters(double cm, LengthUnit unit) {
    switch (unit) {
      case LengthUnit.centimeters:
        return cm;
      case LengthUnit.inches:
        return cm / 2.54;
      case LengthUnit.feet:
        return cm / 30.48;
    }
  }

  static const double litersPerCubicCentimeter = 0.001;
  static const double litersPerGallonUS = 3.785411784;
  static const double litersPerGallonImperial = 4.54609;

  static double litersToGallonsUS(double liters) => liters / litersPerGallonUS;
  static double gallonsUSToLiters(double gallons) =>
      gallons * litersPerGallonUS;
  static double litersToGallonsImperial(double liters) =>
      liters / litersPerGallonImperial;
  static double gallonsImperialToLiters(double gallons) =>
      gallons * litersPerGallonImperial;
}
