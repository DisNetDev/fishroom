import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {super.key,
      this.hintText,
      this.characterLimit,
      this.exampleText,
      this.focusNode,
      this.initialValue,
      this.obscureText = false,
      this.onChanged,
      this.padding = const EdgeInsets.symmetric(horizontal: 16),
      this.margin = const EdgeInsets.symmetric(horizontal: 16),
      this.suffix,
      this.onEditingComplete,
      this.height,
      this.keyboardType,
      this.label,
      this.prefixIcon,
      this.onTap,
      this.controller,
      this.validator});

  final String? hintText;
  final int? characterLimit;
  final String? exampleText;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool obscureText;
  final Function()? onEditingComplete;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget? suffix;
  final double? height;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Widget? label;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final Function()? onTap;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  FocusNode focusNode = FocusNode();

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
        child: Column(
          children: [
            TextFormField(
              onTap: widget.onTap,
              validator: widget.validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) =>
                  null,
              maxLength: widget.characterLimit,
              focusNode: widget.focusNode ?? focusNode,
              initialValue: widget.initialValue,
              onChanged: widget.onChanged,
              onEditingComplete: () {
                focusNode.unfocus();
                widget.onEditingComplete?.call();
              },
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              decoration: widget.height == 0
                  ? const InputDecoration(
                      border: InputBorder.none,
                    )
                  : InputDecoration(
                      errorMaxLines: 3,
                      errorStyle: kDateTimeTextStyle.copyWith(
                        color: Colors.deepOrange,
                      ),
                      alignLabelWithHint: true,
                      labelStyle: kHintTextStyle,
                      label: widget.label,
                      prefixIcon: widget.prefixIcon,
                      suffix: widget.suffix,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      focusedBorder: _focusedBorder,
                      enabledBorder: _enabledBorder,
                      focusedErrorBorder: _errorGradient,
                      errorBorder: _errorGradient,
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
            ),
            if (widget.exampleText != null) ...[
              const Gap(5),
              Text(
                textAlign: TextAlign.center,
                widget.exampleText!,
                style: kDateTimeTextStyle.copyWith(color: Colors.grey),
              )
            ]
          ],
        ),
      ),
    );
  }

  GradientOutlineInputBorder get _focusedBorder => GradientOutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(colors: [
        isDarkMode(context) ? kSecondaryColor : kPrimaryColor,
        Colors.grey,
        isDarkMode(context) ? kSecondaryColor : kPrimaryColor,
      ]));

  GradientOutlineInputBorder get _enabledBorder => GradientOutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(colors: [
        Colors.grey.shade300,
        Colors.grey,
        Colors.grey.shade300,
      ]));

  GradientOutlineInputBorder get _errorGradient => GradientOutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(colors: [
        Colors.red,
        Colors.grey,
        Colors.red,
      ]));
}
