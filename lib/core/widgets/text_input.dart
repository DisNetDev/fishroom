import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_underline_input_border.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {super.key,
      this.hintText,
      this.focusNode,
      this.initialValue,
      this.obscureText = false,
      this.onChanged,
      this.padding = const EdgeInsets.symmetric(horizontal: 16),
      this.margin = const EdgeInsets.symmetric(horizontal: 16),
      this.suffix,
      this.height,
      this.keyboardType,
      this.label,
      this.prefixIcon});

  final String? hintText;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool obscureText;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget? suffix;
  final double? height;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Widget? label;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
      margin: widget.margin,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextFormField(
          focusNode: widget.focusNode,
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          decoration: widget.height == 0
              ? const InputDecoration(
                  border: InputBorder.none,
                )
              : InputDecoration(
                  alignLabelWithHint: true,
                  labelStyle: kHintTextStyle,
                  label: widget.label,
                  prefixIcon: widget.prefixIcon,
                  suffix: widget.suffix,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  focusedBorder: const GradientUnderlineInputBorder(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        kPrimaryColor,
                        kPrimaryColor,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  enabledBorder: const GradientUnderlineInputBorder(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.grey,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
        ),
      ),
    );
  }
}
