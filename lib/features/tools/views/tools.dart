import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/tools/water_volume_calc/water_volume_calc.dart';
import 'package:flutter/material.dart';
import 'package:fishroom/features/tools/co2_kh_ph/co2_kh_ph.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: RootSliverAppBar(
            title: 'Tools',
            implyLeading: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Column(
                children: [
                  NeoBruteBorder(
                    child: ListTile(
                      title: Text('Water Volume Calculator'),
                      onTap: () {
                        navPush(context, WaterVolumeCalc());
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  NeoBruteBorder(
                    child: ListTile(
                      title: Text('CO2 Calculator'),
                      onTap: () {
                        navPush(context, const Co2KhPhTool());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
