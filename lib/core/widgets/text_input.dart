import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {super.key,
      this.hintText,
      this.obscureText = false,
      this.onChanged,
      this.padding = const EdgeInsets.symmetric(horizontal: 16),
      this.margin = const EdgeInsets.symmetric(horizontal: 16),
      this.suffix,
      this.keyboardType,
      this.label,
      this.prefixIcon});

  final String? hintText;
  final Function(String)? onChanged;
  final bool obscureText;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget? suffix;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Widget? label;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelStyle: kHintTextStyle,
            label: widget.label,
            prefixIcon: widget.prefixIcon,
            suffix: widget.suffix,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2000),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2000),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 95, 95, 95),
              ),
            ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(2000),
            //   borderSide: const BorderSide(
            //     color: Color.fromARGB(255, 95, 95, 95),
            //   ),
            // ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
