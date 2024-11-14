import 'dart:math';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/tank_reading/usecases/parameters.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
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
                      )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.parameter.shortName,
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
          )),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 1,
                  height: 50,
                  decoration: const BoxDecoration(
                      border: GradientBoxBorder(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                        kPrimaryColor,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        kPrimaryColor,
                      ]))),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: const GradientBoxBorder(gradient: kPrimaryGradient),
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
                          onSelectedItemChanged: (index) {
                            widget
                                .valueSelected(widget.parameter.values[index]);
                          },
                          diameterRatio: 0.9,
                          physics: enabled
                              ? const FixedExtentScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          itemExtent: 30,
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: widget.parameter.values.length,
                            builder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Transform.rotate(
                                  angle: pi / 2,
                                  child: Text(
                                    widget.parameter.values[index] % 1 == 0
                                        ? widget.parameter.values[index]
                                            .toStringAsFixed(0)
                                        : widget.parameter.values[index]
                                            .toString(),
                                    style: kHeading1TextStyle,
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
