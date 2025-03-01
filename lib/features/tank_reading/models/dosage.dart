import 'package:fishroom/features/fertilizers/models/fertilizer.dart';

class Dosage {
  Dosage({required this.fertilizer, required this.amount});
  final Fertilizer fertilizer;
  final double? amount;

  factory Dosage.fromJson(Map<String, dynamic> json) {
    return Dosage(
      fertilizer: Fertilizer.fromJson(json['fertilizer']),
      amount: json['amount'] as double?,
    );
  }

  toJson() {
    return {
      'fertilizer': fertilizer.toJson(),
      'amount': amount,
    };
  }

  Dosage copyWith({Fertilizer? fertilizer, double? amount}) {
    return Dosage(
      fertilizer: fertilizer ?? this.fertilizer,
      amount: amount ?? this.amount,
    );
  }
}
