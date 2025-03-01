import '../models/fertilizer.dart';

bool areFertilizersEdited(
    List<Fertilizer> fertilizers, List<Fertilizer> defaults) {
  if (fertilizers.length != defaults.length) return true;
  for (var i = 0; i < fertilizers.length; i++) {
    if (fertilizers[i].id != defaults[i].id) return true;
    if (fertilizers[i].name != defaults[i].name) return true;
    if (fertilizers[i].dosage != defaults[i].dosage) return true;
    if (fertilizers[i].perVolume != defaults[i].perVolume) return true;
  }

  return false;
}
