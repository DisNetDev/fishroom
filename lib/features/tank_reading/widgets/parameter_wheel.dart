import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/tank_reading/usecases/parameters.dart';
import 'package:flutter/material.dart';

class ParameterWheel extends StatefulWidget {
  const ParameterWheel(
      {super.key,
      required this.valueSelected,
      required this.parameter,
      required this.onEnabled});

  final Parameter parameter;
  final void Function(double) valueSelected;
  final void Function(bool) onEnabled;

  @override
  State<ParameterWheel> createState() => _ParameterWheelState();
}

class _ParameterWheelState extends State<ParameterWheel> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.transparent,
              ],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Container(
            color: kPrimaryColor.withOpacity(0.2),
            height: 200,
            width:
                MediaQuery.of(context).size.width / readingParameters.length -
                    12,
            child: ListWheelScrollView.useDelegate(
              onSelectedItemChanged: (index) {
                widget.valueSelected(widget.parameter.values[index]);
              },
              diameterRatio: 0.9,
              physics: enabled
                  ? const FixedExtentScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemExtent: 20,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.parameter.values.length,
                builder: (context, index) {
                  return Text(
                    widget.parameter.values[index] % 1 == 0
                        ? widget.parameter.values[index].toStringAsFixed(0)
                        : widget.parameter.values[index].toString(),
                    style: kHeading1TextStyle,
                    textScaler: TextScaler.noScaling,
                  );
                },
              ),
            ),
          ),
        ),
        Text(
          " ${widget.parameter.shortName}",
          style: kHeading1TextStyle,
          textScaler: TextScaler.noScaling,
        ),
        Text(
          widget.parameter.unit,
          style: kHintTextStyle.copyWith(fontStyle: FontStyle.italic),
          textScaler: TextScaler.noScaling,
        ),
        Checkbox(
            activeColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20), // Make the checkbox round
            ),
            value: enabled,
            onChanged: (value) => setState(
                  () {
                    enabled = value ?? false;
                    widget.onEnabled(value ?? false);
                  },
                ))
      ],
    );
  }
}
