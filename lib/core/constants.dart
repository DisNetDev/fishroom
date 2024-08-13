import 'package:flutter/material.dart';

const TextStyle kHintTextStyle = TextStyle(color: Colors.white);
const TextStyle kPlainTextStyle = TextStyle();

const Color kPrimaryColor = Color.fromARGB(255, 131, 145, 255);
const Color kSecondaryColor = Color.fromARGB(255, 154, 221, 255);

const LinearGradient kPrimaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [kPrimaryColor, kSecondaryColor],
);
