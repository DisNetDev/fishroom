import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PricingOptionCard extends StatelessWidget {
  const PricingOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String price;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: NeoBruteBorder(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kPrimaryColor,
                  kTertiaryColor,
                ],
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: kHeading1TextStyle.copyWith(color: Colors.white),
                      ),
                      Text(
                        description,
                        style: kHeading2TextStyle.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Text(price,
                    style: kHeadingTextStyle.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
