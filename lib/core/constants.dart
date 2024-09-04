import 'package:flutter/material.dart';

const TextStyle kHintTextStyle =
    TextStyle(color: Color.fromARGB(255, 125, 125, 125));
const TextStyle kPlainTextStyle = TextStyle();

const Color kPrimaryColor = Color.fromARGB(255, 0, 199, 253);
const Color kSecondaryColor = Color.fromARGB(255, 32, 61, 224);

const LinearGradient kPrimaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [kPrimaryColor, kSecondaryColor],
);
