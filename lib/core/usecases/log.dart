fishLog(Object object, {String? prefix = ""}) {
  print("---------------------------");
  print("$prefix${prefix != null ? ":" : ""} ${object.toString()}");
}
