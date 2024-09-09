import 'package:flutter/material.dart';

class Selectable extends StatefulWidget {
  const Selectable({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
  });

  final bool value;
  final void Function(bool?)? onChanged;
  final String text;

  @override
  State<Selectable> createState() => _SelectableState();
}

class _SelectableState extends State<Selectable> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.value,
          onChanged: widget.onChanged,
          shape: const CircleBorder(),
        ),
        Text(widget.text)
      ],
    );
  }
}
