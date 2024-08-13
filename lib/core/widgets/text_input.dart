import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {super.key,
      this.hintText,
      this.onChanged,
      this.padding = const EdgeInsets.symmetric(horizontal: 16),
      this.margin = const EdgeInsets.symmetric(horizontal: 16),
      this.suffix,
      this.keyboardType,
      this.label,
      this.prefixIcon});

  final String? hintText;
  final Function(String)? onChanged;
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
      padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5, right: 10),
      decoration: BoxDecoration(
        gradient: kPrimaryGradient,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            alignLabelWithHint: true,
            labelStyle: kHintTextStyle,
            label: widget.label,
            prefixIcon: widget.prefixIcon,
            suffix: widget.suffix,
            border: InputBorder.none,
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
