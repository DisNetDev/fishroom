import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../fertilizers/models/fertilizer.dart';

class DosageWidget extends StatelessWidget {
  const DosageWidget(
      {super.key,
      required this.fertilizer,
      required this.enabled,
      required this.onTap,
      required this.onChanged});

  final Fertilizer fertilizer;
  final bool enabled;
  final Function() onTap;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Checkbox(
              value: enabled,
              onChanged: (_) {},
              shape: CircleBorder(),
            ),
            Gap(10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fertilizer.name,
                    style: kHeading2TextStyle,
                  ),
                  Text(
                    "${fertilizer.dosage}${fertilizer.dosageUnit} per ${fertilizer.perVolume}${fertilizer.perVolumeUnit}",
                    style: kDateTimeTextStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: TextInput(
                suffix: Text(fertilizer.dosageUnit),
                validator: (value) => double.tryParse(value) == null &&
                        value.isNotEmpty
                    ? "Please enter a valid number. Avoid using commas, use dots instead."
                    : null,
                onChanged: onChanged,
                hintText: "Amount",
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
