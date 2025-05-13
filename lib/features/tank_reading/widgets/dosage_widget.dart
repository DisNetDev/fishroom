import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: NeoBruteBorder(
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Checkbox(
                  value: enabled,
                  onChanged: (_) {},
                  shape: CircleBorder(),
                ),
                Expanded(
                  flex: 2,
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
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      validator: (value) => double.tryParse(value ?? "") ==
                                  null &&
                              value?.isNotEmpty == true
                          ? "Please enter a valid number. Avoid using commas, use dots instead."
                          : null,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintFadeDuration: const Duration(milliseconds: 400),
                        hintText: "Amount",
                        suffix: Text(fertilizer.dosageUnit),
                        hintStyle: kHintTextStyle,
                        border: InputBorder.none,
                      ),
                      onChanged: onChanged,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
