import '../models/units.dart';

class WaterVolumeService {
  static double litersFromDimensions({
    required double length,
    required double width,
    required double height,
    required LengthUnit lengthUnit,
  }) {
    final lCm = UnitConverter.toCentimeters(length, lengthUnit);
    final wCm = UnitConverter.toCentimeters(width, lengthUnit);
    final hCm = UnitConverter.toCentimeters(height, lengthUnit);

    final cubicCm = lCm * wCm * hCm;
    final liters = cubicCm * UnitConverter.litersPerCubicCentimeter;
    return liters;
  }

  static double litersFromCylinder({
    required double diameter,
    required double height,
    required LengthUnit lengthUnit,
  }) {
    final dCm = UnitConverter.toCentimeters(diameter, lengthUnit);
    final hCm = UnitConverter.toCentimeters(height, lengthUnit);
    final radiusCm = dCm / 2.0;
    final baseAreaCubicCm = 3.141592653589793 * radiusCm * radiusCm;
    final cubicCm = baseAreaCubicCm * hCm;
    final liters = cubicCm * UnitConverter.litersPerCubicCentimeter;
    return liters;
  }

  static double volumeInUnit({
    required double length,
    required double width,
    required double height,
    required LengthUnit lengthUnit,
    required VolumeUnit volumeUnit,
  }) {
    final liters = litersFromDimensions(
      length: length,
      width: width,
      height: height,
      lengthUnit: lengthUnit,
    );

    switch (volumeUnit) {
      case VolumeUnit.liters:
        return liters;
      case VolumeUnit.gallonsUS:
        return UnitConverter.litersToGallonsUS(liters);
      case VolumeUnit.gallonsImperial:
        return UnitConverter.litersToGallonsImperial(liters);
    }
  }

  static double volumeForShape({
    required TankShape shape,
    required LengthUnit lengthUnit,
    required VolumeUnit volumeUnit,
    double? length,
    double? width,
    double? height,
    double? diameter,
  }) {
    final liters = switch (shape) {
      TankShape.rectangular => litersFromDimensions(
          length: length ?? 0,
          width: width ?? 0,
          height: height ?? 0,
          lengthUnit: lengthUnit,
        ),
      TankShape.cylindrical => litersFromCylinder(
          diameter: diameter ?? 0,
          height: height ?? 0,
          lengthUnit: lengthUnit,
        ),
    };

    return switch (volumeUnit) {
      VolumeUnit.liters => liters,
      VolumeUnit.gallonsUS => UnitConverter.litersToGallonsUS(liters),
      VolumeUnit.gallonsImperial =>
        UnitConverter.litersToGallonsImperial(liters),
    };
  }
}
