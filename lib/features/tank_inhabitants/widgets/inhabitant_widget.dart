import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/capitalize_each_word.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/features/tank_inhabitants/widgets/inhabitant_details.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: GestureDetector(
        onTap: () => showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => InhabitantDetails(
            inhabitant: inhabitant,
            onAdd: (inhabitant) => onAdd(inhabitant),
          ),
        ),
        child: NeoBruteBorder(
          child: Skeletonizer(
            enabled: loading,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (inhabitant.commonName != null &&
                            inhabitant.commonName!.isNotEmpty)
                          Text(
                            capitalizeEachWord(inhabitant.commonName ?? ""),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        Text(
                          capitalizeEachWord(inhabitant.scientificName),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: (inhabitant.commonName != null &&
                                  inhabitant.commonName!.isNotEmpty)
                              ? kDateTimeTextStyle
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Gap(20),
                  if (inhabitant.count != null && inhabitant.count! > 0)
                    Text(
                      "x${inhabitant.count}",
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
