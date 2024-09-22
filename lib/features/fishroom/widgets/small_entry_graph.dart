import 'package:flutter/material.dart';

import 'bar_segment.dart';

class SmallEntryGraph extends StatefulWidget {
  const SmallEntryGraph({super.key});

  @override
  State<SmallEntryGraph> createState() => _SmallEntryGraphState();
}

class _SmallEntryGraphState extends State<SmallEntryGraph> {
  @override
  Widget build(BuildContext context) {

    
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BarSegment(color: Colors.red),
        BarSegment(color: Colors.blue),
        BarSegment(color: Colors.green),
        BarSegment(color: Colors.yellow),
        BarSegment(color: Colors.purple),
      ],
    );
  }
}
