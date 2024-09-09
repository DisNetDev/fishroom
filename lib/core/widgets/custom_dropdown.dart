import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.entries,
    this.margin = const EdgeInsets.symmetric(horizontal: 8),
    this.padding = const EdgeInsets.only(left: 16),
    this.onSelected,
    this.hintText,
    this.label,
  });

  final Function(dynamic)? onSelected;
  final List<DropdownMenuEntry> entries;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String? hintText;
  final Widget? label;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: DropdownMenu(
        label: widget.label,
        trailingIcon: const Icon(Icons.keyboard_arrow_down),
        hintText: widget.hintText,
        onSelected: widget.onSelected,
        inputDecorationTheme:
            const InputDecorationTheme(border: InputBorder.none),
        dropdownMenuEntries: widget.entries,
      ),
    );
  }
}
