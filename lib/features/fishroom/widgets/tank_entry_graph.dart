import 'package:fishroom/core/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';

// ignore: prefer-match-file-name
class TankEntryGraphData extends StatefulWidget {
  const TankEntryGraphData({super.key, required this.data});

  final TankReading data;

  @override
  State<TankEntryGraphData> createState() => _TankEntryGraphState();
}

class _TankEntryGraphState extends State<TankEntryGraphData> {
  double highestValue = 0;
  double lowestValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      swapAnimationCurve: Curves.easeOutExpo,
      swapAnimationDuration: const Duration(milliseconds: 500),
      BarChartData(
        extraLinesData: ExtraLinesData(horizontalLines: [
          // HorizontalLine(
          //     y: 0,
          //     color: isDarkMode(context) ? Colors.grey : Colors.black,
          //     strokeWidth: 0.5,
          //     dashArray: [5]),
        ]),
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        groupsSpace: 10,
        gridData: FlGridData(
          horizontalInterval: 1,
          show: false,
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
        minY: lowestValue,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipRoundedRadius: 200,
          getTooltipColor: (_) => Colors.transparent,
          direction: TooltipDirection.auto,
          tooltipPadding: EdgeInsets.all(0),
          tooltipMargin: 5,
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
                  fontSize: 10,
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
        show: false,
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
            interval: 1,
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
        colors: [kSecondaryColor, kPrimaryColor],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups {
    return List.generate(widget.data.parameters.length, (index) {
      double value = widget.data.parameters[index].value!;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value == 0 ? 0 : value,
            gradient: _barsGradient,
            width: 15,
            borderRadius: BorderRadius.circular(2),
          )
        ],
        showingTooltipIndicators: [0],
      );
    });
  }
}

class TankEntryGraph extends StatelessWidget {
  const TankEntryGraph({super.key, required this.data});

  final TankReading data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Skeleton.shade(
          child: TankEntryGraphData(
        data: data,
      )),
    );
  }
}
