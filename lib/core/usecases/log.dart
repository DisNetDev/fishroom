// ignore_for_file: avoid_print

fishLog(Object object, {String? prefix = ""}) {
  print("---------------------------");
  print("$prefix${prefix != null ? ":" : ""} ${object.toString()}");
}
