import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {super.key,
      required this.entries,
      this.margin = const EdgeInsets.symmetric(horizontal: 8),
      this.padding = const EdgeInsets.only(left: 16),
      this.onSelected,
      this.width,
      this.hintText});

  final Function(dynamic)? onSelected;
  final List<DropdownMenuEntry> entries;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double? width;
  final String? hintText;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownMenu(
        trailingIcon: const Icon(Icons.keyboard_arrow_down),
        hintText: widget.hintText,
        width: widget.width,
        onSelected: widget.onSelected,
        inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none),
        dropdownMenuEntries: widget.entries,
      ),
    );
  }
}
