import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';

import 'material_container.dart';

class FishTextBox extends StatefulWidget {
  const FishTextBox(
      {super.key,
      required this.initialValue,
      required this.onChanged,
      this.hintText});

  final void Function(String) onChanged;
  final String initialValue;
  final String? hintText;

  @override
  State<FishTextBox> createState() => _FishTextBoxState();
}

class _FishTextBoxState extends State<FishTextBox> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.black;
    if (isDarkMode(context)) {
      borderColor = Colors.blueGrey;
    } else {
      borderColor = Colors.black26;
    }
    if (isDarkMode(context) && focusNode.hasFocus) {
      borderColor = kPrimaryColor;
    }
    if (!isDarkMode(context) && focusNode.hasFocus) {
      borderColor = kSecondaryColor;
    }

    return MaterialContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(20)),
      constraints: const BoxConstraints(minHeight: 200),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        onChanged: widget.onChanged,
        initialValue: widget.initialValue,
        focusNode: focusNode,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: kHintTextStyle),
        maxLines: 10,
      ),
    );
  }
}
