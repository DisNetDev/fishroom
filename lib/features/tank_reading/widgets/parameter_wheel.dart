import 'dart:math';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../usecases/calculate_values_for_parameter.dart';

class ParameterWheel extends StatefulWidget {
  const ParameterWheel(
      {super.key,
      required this.valueSelected,
      required this.parameter,
      required this.onTap,
      this.initialValue,
      required this.enabled});

  final Parameter parameter;
  final double? initialValue;
  final bool enabled;

  final void Function(double) valueSelected;
  final VoidCallback onTap;

  @override
  State<ParameterWheel> createState() => _ParameterWheelState();
}

class _ParameterWheelState extends State<ParameterWheel> {
  List<double> values = [];

  @override
  void initState() {
    values = calculateValuesForParameter(widget.parameter);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: kPrimaryColor.withOpacity(0.2),
            onTap: () {
              setState(() {
                widget.onTap();
              });
            },
            child: Row(
              children: [
                Checkbox(
                  activeColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Make the checkbox round
                  ),
                  value: widget.enabled,
                  onChanged: (value) {},
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.parameter.shortName ?? "N/A",
                      style: kHeading1TextStyle,
                      textScaler: TextScaler.noScaling,
                    ),
                    Text(
                      "${widget.parameter.name} ${widget.parameter.unit != "" ? "(${widget.parameter.unit})" : ""}",
                      style: kHintTextStyle.copyWith(
                          fontStyle: FontStyle.italic, fontSize: 10),
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          )),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 1,
                  height: 50,
                  decoration: BoxDecoration(
                      border: GradientBoxBorder(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                        widget.enabled ? kPrimaryColor : Colors.grey,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        widget.enabled ? kPrimaryColor : Colors.grey,
                      ]))),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: GradientBoxBorder(
                        gradient: widget.enabled
                            ? kPrimaryGradient
                            : kDisabledGradient),
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.white,
                          Colors.transparent,
                        ],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds);
                    },
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width / 1.5,
                        width: 50,
                        child: ListWheelScrollView.useDelegate(
                          controller: FixedExtentScrollController(
                            initialItem: widget.initialValue != null &&
                                    values.contains(widget.initialValue)
                                ? values.indexOf(widget.initialValue!)
                                : 0,
                          ),
                          onSelectedItemChanged: (index) {
                            widget.valueSelected(values[index]);
                          },
                          diameterRatio: 0.9,
                          physics: widget.enabled
                              ? const FixedExtentScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          itemExtent: 30,
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: values.length,
                            builder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Transform.rotate(
                                  angle: pi / 2,
                                  child: Text(
                                    values[index] % 1 == 0
                                        ? values[index].toStringAsFixed(0)
                                        : values[index].toString(),
                                    style: widget.enabled
                                        ? kHeading1TextStyle
                                        : kHeading1TextStyle.copyWith(
                                            color: Colors.grey),
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
