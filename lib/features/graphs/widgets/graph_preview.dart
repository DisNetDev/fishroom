import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../app/cubit/app_cubit.dart';

// ignore: prefer-match-file-name
class ParameterChartData extends StatefulWidget {
  const ParameterChartData(
      {super.key, required this.data, required this.parameterToFilter});

  final List<TankReading> data;
  final Parameter parameterToFilter;

  @override
  State<ParameterChartData> createState() => _ParameterChartDataState();
}

class _ParameterChartDataState extends State<ParameterChartData> {
  double highestValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    highestValue = widget.data
        .map((reading) => reading.parameters
            .firstWhere(
              (param) => param.name == widget.parameterToFilter.name,
              orElse: () => Parameter(value: 1),
            )
            .value)
        .reduce((value, element) => value! > element! ? value : element)!;

    double lineInterval = _getInterval(highestValue, widget: widget);

    return BarChart(
      swapAnimationCurve: Curves.easeOutExpo,
      swapAnimationDuration: const Duration(milliseconds: 500),
      BarChartData(
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(
              y: 0,
              color: isDarkMode(context) ? Colors.grey : Colors.black,
              strokeWidth: 0.5,
              dashArray: [5]),
          HorizontalLine(
              y: highestValue,
              color: isDarkMode(context) ? Colors.grey : Colors.black,
              strokeWidth: 0.5,
              dashArray: [5])
        ]),
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        groupsSpace: 2,
        gridData: FlGridData(
          horizontalInterval: lineInterval,
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: isDarkMode(context) ? Colors.white24 : Colors.grey,
                strokeWidth: 0.5,
                dashArray: [5]);
          },
          drawVerticalLine: false,
        ),
        alignment: BarChartAlignment.start,
        maxY: highestValue,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipRoundedRadius: 200,
          getTooltipColor: (_) => kSecondaryColor,
          direction: TooltipDirection.auto,
          tooltipPadding: EdgeInsets.all(8),
          tooltipMargin: 10,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.toString(),
              TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      default:
        text = '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            interval: _getInterval(highestValue, widget: widget) * 2,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [kPrimaryColor, kSecondaryColor],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups {
    List<Parameter> parameters = [];

    for (TankReading reading in widget.data) {
      for (Parameter param in reading.parameters) {
        if (param.name == widget.parameterToFilter.name) {
          if (param.value != null) {
            parameters.add(param);
          }
        }
      }
    }

    return List.generate(parameters.length, (index) {
      double value = parameters[index].value!;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value == 0 ? 0.0000000001 : value,
            gradient: _barsGradient,
            width: 10,
          )
        ],
        showingTooltipIndicators: [1],
      );
    });
  }
}

class ParameterChart extends StatefulWidget {
  const ParameterChart({
    super.key,
    required this.data,
  });

  final List<TankReading> data;

  @override
  State<StatefulWidget> createState() => ParameterChartState();
}

class ParameterChartState extends State<ParameterChart> {
  List<TankReading> data = [];
  Parameter? parameterFilter;

  @override
  void initState() {
    if (widget.data.length > 29) {
      data = widget.data.getRange(0, 30).toList();
    } else {
      data = widget.data;
    }

    if (context.read<AppCubit>().state.settings.parameters.isNotEmpty) {
      parameterFilter =
          context.read<AppCubit>().state.settings.parameters.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(50),
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Skeleton.shade(
                child: ParameterChartData(
                    data: data,
                    parameterToFilter: parameterFilter ??
                        context
                            .read<AppCubit>()
                            .state
                            .settings
                            .parameters
                            .first)),
          ),
        ),
        Gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount:
                context.read<AppCubit>().state.settings.parameters.length > 7
                    ? 6
                    : context.read<AppCubit>().state.settings.parameters.length,
            childAspectRatio: 2,
            children: [
              for (Parameter parameter
                  in context.read<AppCubit>().state.settings.parameters)
                _SelectedFilter(
                  parameter: parameter,
                  onSelected: (param) {
                    setState(() {
                      parameterFilter = param;
                      if (data.length > 29) {
                        data = widget.data.getRange(0, 30).toList();
                      } else {
                        data = widget.data;
                      }
                    });
                  },
                  isSelected: parameterFilter?.name == parameter.name,
                )
            ],
          ),
        ),
        Gap(20),
      ],
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

double _getInterval(double highestValue, {required ParameterChartData widget}) {
  highestValue = widget.data
      .map((reading) => reading.parameters
          .firstWhere(
            (param) => param.name == widget.parameterToFilter.name,
            orElse: () => Parameter(value: 1),
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
