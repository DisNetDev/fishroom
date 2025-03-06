import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/datetime_format.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../app/cubit/app_cubit.dart';
import '../../fishroom/cubit/tanks_cubit.dart';
import '../../tank_reading/models/parameter.dart';
import '../usecases/highest_lowest.dart';

class LineGraphMain extends StatefulWidget {
  const LineGraphMain({super.key, required this.data});
  final List<TankReading> data;

  @override
  State<LineGraphMain> createState() => _LineGraphMainState();
}

class _LineGraphMainState extends State<LineGraphMain> {
  Parameter? parameterFilter;
  Tank? get tank => context
      .read<TanksCubit>()
      .state
      .tanks
      .firstWhereOrNull((test) => test.id == widget.data.firstOrNull?.tankId);

  Target? get target => tank?.targets
      .firstWhereOrNull((test) => test.paramID == parameterFilter?.id);

  List<Color> gradientColors = [kPrimaryColor, kSecondaryColor];

  bool showAvg = false;

  @override
  void initState() {
    parameterFilter =
        context.read<AppCubit>().state.settings.parameters.firstOrNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasData = widget.data.isNotEmpty;
    if (widget.data.any((reading) =>
        reading.parameters.any((param) => param.id == parameterFilter?.id))) {
      hasData = true;
    } else {
      hasData = false;
    }

    if (context.read<AppCubit>().state.settings.parameters.isEmpty) {
      hasData = false;
    }

    return Stack(
      children: [
        Column(
          children: [
            AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: hasData
                    ? LineChart(
                        mainData(),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Text("No Data"),
                          Opacity(
                            opacity: 0.2,
                            child: LineChart(placeholderData()),
                          ),
                        ],
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                children: [
                  for (Parameter parameter
                      in context.read<AppCubit>().state.settings.parameters)
                    _SelectedFilter(
                      parameter: parameter,
                      onSelected: (param) {
                        if (param.id == parameterFilter?.id) return;
                        setState(
                          () {
                            parameterFilter = param;
                          },
                        );
                      },
                      isSelected: parameterFilter?.id == parameter.id,
                    )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('', style: style);
        break;
      case 5:
        text = const Text('', style: style);
        break;
      case 8:
        text = const Text('', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = value.toStringAsFixed(2);

    return Text(text, style: kDateTimeTextStyle, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    List<TankReading> filteredData = widget.data
        .where((reading) =>
            reading.parameters.any((param) => param.id == parameterFilter?.id))
        .toList();

    double targetMinValue = target?.minValue ?? 0;
    double targetMaxValue = target?.maxValue ?? 0;

    double highestValue = getHighestValue(filteredData, parameterFilter!);
    double lineInterval = _getInterval(highestValue,
        data: filteredData, parameter: parameterFilter!);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: lineInterval,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: isDarkMode(context) ? kPrimaryColor : kSecondaryColor,
            strokeWidth: 0.3,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: isDarkMode(context) ? kPrimaryColor : kSecondaryColor,
            strokeWidth: 0.3,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 0,
            interval: lineInterval,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: lineInterval,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30, //Side Title Widgets Width
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: !isDarkMode(context) ? kPrimaryColor : kSecondaryColor,
          width: 0.5,
        ),
      ),

      //CHART SIZE
      minX: getGraphMinX(filteredData, parameterFilter!),
      maxX: getGraphWidth(filteredData, parameterFilter!),
      minY: getLowestValue(filteredData, parameterFilter!),
      maxY: getHighestValue(filteredData, parameterFilter!),

      //CHART DATA
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          spots: List.generate(
              filteredData.length,
              (index) => FlSpot(
                  index.toDouble(),
                  filteredData[index]
                          .parameters
                          .firstWhere(
                              (param) => param.id == parameterFilter?.id)
                          .value ??
                      0)),
          isCurved: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors.reversed.toList(),
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideVertically: true,
          fitInsideHorizontally: true,
          tooltipBorder: BorderSide(color: kSecondaryColor),
          getTooltipColor: (touchedSpot) =>
              isDarkMode(context) ? Colors.black : Colors.white,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = kDateTimeTextStyle;

              return LineTooltipItem(
                '${formatDateTime(filteredData[touchedSpot.x.toInt()].createdAt)}\n${touchedSpot.y.toStringAsFixed(2)} ${parameterFilter?.shortName}',
                textStyle,
              );
            }).toList();
          },
        ),
      ),
    )
      ..lineBarsData.add(
        LineChartBarData(
          preventCurveOverShooting: true,

          dotData: const FlDotData(show: false),
          show: !(targetMinValue <
              getLowestValue(
                  filteredData, parameterFilter ?? Parameter(id: ''))),
          spots: [
            FlSpot(0, targetMinValue), // Start point
            FlSpot(getGraphWidth(filteredData, parameterFilter!),
                targetMinValue), // End point
          ],
          isCurved: false,
          color: targetMinValue < getLowestValue(filteredData, parameterFilter!)
              ? Colors.transparent
              : Colors.red.withAlpha(100), // Color for the target line
          barWidth: 1,
          belowBarData: BarAreaData(show: false),
        ),
      )
      ..lineBarsData.add(
        LineChartBarData(
          preventCurveOverShooting: true,
          dotData: const FlDotData(show: false),
          show: !(targetMaxValue >
              getHighestValue(
                  filteredData, parameterFilter ?? Parameter(id: ''))),
          spots: [
            FlSpot(0, targetMaxValue), // Start point
            FlSpot(getGraphWidth(filteredData, parameterFilter!),
                targetMaxValue), // End point
          ],
          isCurved: false,
          color: targetMaxValue < getLowestValue(filteredData, parameterFilter!)
              ? Colors.transparent
              : Colors.red.withAlpha(100), // Color for the target line
          barWidth: 1,
          belowBarData: BarAreaData(show: false),
        ),
      );
  }

  LineChartData placeholderData() {
    List<TankReading> filteredData = [
      for (int i = 0; i < 10; i++)
        TankReading(
          id: '1',
          ownerId: '1',
          tankId: '1',
          type: TankReadingType.measurement,
          createdAt: DateTime.now().toString(),
          parameters: [
            Parameter(
              shortName: 'pH',
              value: Random().nextInt(14).toDouble(),
              max: 14,
              id: '1',
            ),
          ],
        ),
    ];

    double lineInterval = 1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: lineInterval,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 0.3,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 0.3,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 0,
            interval: lineInterval,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: lineInterval,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30, //Side Title Widgets Width
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),

      //CHART SIZE
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: 10,

      //CHART DATA
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            10,
            (index) =>
                FlSpot(index.toDouble(), Random().nextInt(10).toDouble()),
          ),
          isCurved: true,
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.grey],
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.grey.shade800.withValues(alpha: 0.3), Colors.grey]
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideVertically: true,
          fitInsideHorizontally: true,
          tooltipBorder: BorderSide(color: kSecondaryColor),
          getTooltipColor: (touchedSpot) =>
              isDarkMode(context) ? Colors.black : Colors.white,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = kDateTimeTextStyle;

              return LineTooltipItem(
                '${formatDateTime(filteredData[touchedSpot.x.toInt()].createdAt)}\n${touchedSpot.y.toStringAsFixed(2)} ${parameterFilter?.shortName}',
                textStyle,
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

class _SelectedFilter extends StatelessWidget {
  const _SelectedFilter(
      {required this.parameter, this.onSelected, required this.isSelected});

  final Parameter parameter;
  final Function(Parameter parameter)? onSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected!(parameter),
      child: Container(
        width: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          border: GradientBoxBorder(
              gradient: isSelected
                  ? kErrorGradient
                  : LinearGradient(colors: [Colors.grey, Colors.blueGrey])),
        ),
        child: Text(
          parameter.shortName ?? "!",
          style: kDateTimeTextStyle,
        ),
      ),
    );
  }
}

double _getInterval(double highestValue,
    {required List<TankReading> data, required Parameter parameter}) {
  highestValue = data
      .map((reading) => reading.parameters
          .firstWhere(
            (param) => param.id == parameter.id,
            orElse: () => Parameter(value: 0, id: ''),
          )
          .value)
      .reduce((value, element) => value! > element! ? value : element)!;
  double lineInterval = 10;
  switch (highestValue) {
    case > 400:
      lineInterval = 100;
      break;
    case > 200:
      lineInterval = 50;
      break;
    case > 100:
      lineInterval = 25;
      break;
    case > 50:
      lineInterval = 10;
      break;
    case > 20:
      lineInterval = 5;
      break;
    case > 10:
      lineInterval = 1;
      break;
    case > 5:
      lineInterval = 0.5;
      break;
    case > 2:
      lineInterval = 0.25;
      break;
    case > 1:
      lineInterval = 0.1;
      break;
    case > 0.5:
      lineInterval = 0.05;
      break;
    case > 0.25:
      lineInterval = 0.025;
      break;
    case > 0.1:
      lineInterval = 0.01;
      break;
    case > 0.05:
      lineInterval = 0.005;
      break;
    default:
      lineInterval = 0.005;
  }

  return lineInterval;
}
