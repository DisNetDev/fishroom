import 'package:flutter/material.dart';

const TextStyle kHintTextStyle =
    TextStyle(color: Color.fromARGB(255, 125, 125, 125));
const TextStyle kPlainTextStyle = TextStyle();
const TextStyle kDateTimeTextStyle = TextStyle(
  fontSize: 10,
  fontStyle: FontStyle.italic,
);
const TextStyle kHeading2TextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
const TextStyle kHeading1TextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w800,
);

const Color kPrimaryColor = Color.fromARGB(255, 0, 199, 253);
const Color kSecondaryColor = Color.fromARGB(255, 32, 61, 224);

const LinearGradient kPrimaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [kPrimaryColor, kSecondaryColor],
);

const LinearGradient kErrorGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color.fromARGB(255, 253, 118, 0), Color.fromARGB(255, 224, 32, 32)],
);

const LinearGradient kSuccessGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color.fromARGB(255, 169, 253, 0), Color.fromARGB(255, 32, 224, 38)],
);
