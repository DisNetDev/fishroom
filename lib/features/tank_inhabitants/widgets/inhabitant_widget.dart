import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/inhabitant.dart';

class InhabitantWidget extends StatelessWidget {
  const InhabitantWidget({super.key, required this.inhabitant});

  final Inhabitant inhabitant;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (inhabitant.commonName != null &&
                  inhabitant.commonName!.isNotEmpty)
                Text(
                  toBeginningOfSentenceCase(
                    (inhabitant.commonName!)
                        .split(' ')
                        .map(
                            (word) => word[0].toUpperCase() + word.substring(1))
                        .join(' '),
                  ),
                ),
              Text(
                inhabitant.scientificName,
                style: (inhabitant.commonName != null &&
                        inhabitant.commonName!.isNotEmpty)
                    ? kDateTimeTextStyle
                    : null,
              )
            ],
          ),
        ],
      ),
    );
  }
}
