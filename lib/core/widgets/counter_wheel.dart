import 'dart:math';

import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class CounterWheel extends StatefulWidget {
  const CounterWheel({
    super.key,
    required this.valueSelected,
    this.initialValue,
  });

  final void Function(double) valueSelected;
  final double? initialValue;

  @override
  State<CounterWheel> createState() => _CounterWheelState();
}

class _CounterWheelState extends State<CounterWheel> {
  List<double> values = [];
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    values = List.generate(400, (index) => index.toDouble());

    // Initialize the controller with the initial index
    _controller = FixedExtentScrollController(
      initialItem: widget.initialValue != null
          ? values.indexOf(widget.initialValue!)
          : 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                kPrimaryColor,
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                kPrimaryColor
              ]))),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: GradientBoxBorder(gradient: kPrimaryGradient),
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
                  controller: _controller,
                  onSelectedItemChanged: (index) {
                    widget.valueSelected(values[index]);
                  },
                  diameterRatio: 0.9,
                  physics: const FixedExtentScrollPhysics(),
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
    );
  }
}
