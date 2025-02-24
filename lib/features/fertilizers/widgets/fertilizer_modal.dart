import 'package:flutter/material.dart';

import '../models/fertilizer.dart';

class FertilizerModal extends StatelessWidget {
  const FertilizerModal({super.key, required this.onAdd});

  final Function(Fertilizer fertilizer) onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Text("Add Fertilizer"),
    );
  }
}
