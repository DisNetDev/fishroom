import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
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
      this.validator,
      this.isMultiline = false});

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
  final bool? isMultiline;

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
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            NeoBruteBorder(
              showBorder: false,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: TextFormField(
                  maxLines: widget.isMultiline ?? false ? 10 : 1,
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
                              color: Colors.deepOrange, fontSize: 0),
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
      borderRadius: BorderRadius.circular(8),
      width: 2,
      gradient: LinearGradient(colors: [
        kTertiaryColor,
        kSecondaryColor,
        kTertiaryColor,
      ]));

  GradientOutlineInputBorder get _enabledBorder => GradientOutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      width: 2,
      gradient: LinearGradient(colors: [
        Colors.grey,
        Colors.white,
        Colors.grey,
      ]));

  GradientOutlineInputBorder get _errorGradient => GradientOutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      width: 2,
      gradient: LinearGradient(colors: [
        Colors.red,
        kTertiaryColor,
        Colors.red,
      ]));
}
