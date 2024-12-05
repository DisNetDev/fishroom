// ignore_for_file: avoid_print

import 'dart:developer';

fishLog(Object object, {String? prefix = ""}) {
  log("*---------------------------");
  log("*$prefix${prefix != null ? ":" : ""} ${object.toString()}");
}
