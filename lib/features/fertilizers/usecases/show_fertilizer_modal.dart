import 'package:flutter/material.dart';

import '../models/fertilizer.dart';
import '../widgets/fertilizer_modal.dart';

showFertilizerModal(BuildContext context,
    {Fertilizer? fertilizer, required Function(Fertilizer) onAdd}) {
  showModalBottomSheet(
    isDismissible: true,
    enableDrag: true,
    scrollControlDisabledMaxHeightRatio: 0.8,
    context: context,
    builder: (context) => SafeArea(
      child: FertilizerModal(
        fertilizer: fertilizer,
        onAdd: (fertilizer) {
          onAdd(fertilizer);
        },
      ),
    ),
  );
}
