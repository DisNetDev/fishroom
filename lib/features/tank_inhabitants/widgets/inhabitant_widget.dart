import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/capitalize_each_word.dart';
import 'package:fishroom/features/tank_inhabitants/widgets/inhabitant_details.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/usecases/is_dark_mode.dart';
import '../models/inhabitant.dart';

class InhabitantWidget extends StatelessWidget {
  const InhabitantWidget(
      {super.key,
      required this.inhabitant,
      this.loading = false,
      required this.onAdd});

  final Inhabitant inhabitant;
  final bool loading;
  final void Function(Inhabitant) onAdd;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => InhabitantDetails(
          inhabitant: inhabitant,
          onAdd: (inhabitant) => onAdd(inhabitant),
        ),
      ),
      child: Skeletonizer(
        enabled: loading,
        child: Container(
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color:
                Colors.grey.withValues(alpha: isDarkMode(context) ? 0.09 : 0.1),
            borderRadius: BorderRadius.circular(8),
            border: GradientBoxBorder(gradient: kPrimaryGradient),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (inhabitant.commonName != null &&
                      inhabitant.commonName!.isNotEmpty)
                    Text(
                      capitalizeEachWord(inhabitant.commonName ?? ""),
                    ),
                  Text(
                    capitalizeEachWord(inhabitant.scientificName),
                    style: (inhabitant.commonName != null &&
                            inhabitant.commonName!.isNotEmpty)
                        ? kDateTimeTextStyle
                        : null,
                  ),
                ],
              ),
              Expanded(child: Container()),
              if (inhabitant.count != null && inhabitant.count! > 0)
                Text(
                  "x${inhabitant.count}",
                )
            ],
          ),
        ),
      ),
    );
  }
}
