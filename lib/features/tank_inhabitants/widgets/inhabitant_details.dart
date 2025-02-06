import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/constants.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/usecases/nav_push.dart';
import '../../../core/widgets/counter_wheel.dart';
import '../models/inhabitant.dart';

class InhabitantDetails extends StatefulWidget {
  const InhabitantDetails(
      {super.key, required this.inhabitant, required this.onAdd});

  final Inhabitant inhabitant;
  final void Function(Inhabitant) onAdd;

  @override
  State<InhabitantDetails> createState() => _InhabitantDetailsState();
}

class _InhabitantDetailsState extends State<InhabitantDetails> {
  int numberOfInhabitants = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      decoration: BoxDecoration(
        border: GradientBoxBorder(gradient: kPrimaryGradient),
        color: isDarkMode(context) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            widget.inhabitant.commonName ?? widget.inhabitant.scientificName,
            style: kHeadingTextStyle,
            textAlign: TextAlign.center,
          ),
          Gap(10),
          if (widget.inhabitant.commonName != null &&
              widget.inhabitant.commonName!.isNotEmpty)
            Text(
              widget.inhabitant.scientificName,
              style: kHeading1TextStyle.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          Gap(20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                widget.inhabitant.imageUrl ?? "",
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Loader();
                },
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Symbols.image_not_supported_sharp, size: 30),
              ),
            ),
          ),
          Gap(40),
          Text(
              "How many ${widget.inhabitant.commonName ?? widget.inhabitant.scientificName}s do you have?"),
          Gap(10),
          Material(
              color: Colors.transparent,
              child: CounterWheel(
                  initialValue: widget.inhabitant.count?.toDouble(),
                  valueSelected: (value) {
                    setState(() => numberOfInhabitants = value.toInt());
                  })),
          Expanded(child: Container()),
          CustomButton(
              text: widget.inhabitant.count == 0 ? "Add" : "Update",
              onPressed: () {
                navPop(context);
                widget.onAdd(widget.inhabitant.copyWith(
                  count: numberOfInhabitants,
                ));
              })
        ],
      ),
    );
  }
}
