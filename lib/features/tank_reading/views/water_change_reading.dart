import 'package:fishroom/core/models/tank_reading.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/usecases/show_toast.dart';
import '../../app/cubit/app_cubit.dart';
import '../../fishroom/cubit/tanks_cubit.dart';

class WaterChangeReading extends StatefulWidget {
  const WaterChangeReading({super.key, required this.tank});

  final Tank tank;

  @override
  State<WaterChangeReading> createState() => _WaterChangeReadingState();
}

class _WaterChangeReadingState extends State<WaterChangeReading> {
  late TankReading tankReading = TankReading(
    id: const Uuid().v4(),
    ownerId: context.read<AppCubit>().state.user!.uuid,
    type: TankReadingType.waterChange,
    tankId: widget.tank.id,
    createdAt: DateTime.now().toString(),
  );

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RootSliverAppBar(
        title: "Water Change",
        implyLeading: true,
      ),
      body: Stack(
        children: [
          CustomBackground(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(20),
                Text(
                  "What size water change did you make?",
                  textAlign: TextAlign.center,
                  style: kHeadingTextStyle,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "${(tankReading.waterChangePercentage ?? 0).toString()}%",
                      style: kHeadingTextStyle.copyWith(fontSize: 80),
                    ),
                  ),
                ),
                Text(
                  "      Slide to select a value >>>",
                  style: kPlainTextStyle,
                ),
                Slider(
                    min: 0,
                    max: 100,
                    divisions: 20,
                    inactiveColor: Colors.grey,
                    value: (tankReading.waterChangePercentage ?? 0).toDouble(),
                    onChanged: (value) {
                      setState(() {
                        tankReading = tankReading.copyWith(
                            waterChangePercentage: value.toInt());
                      });
                    }),
                Gap(50),
                CustomButton(
                    text: "Save Water Change",
                    loading: loading,
                    onPressed: () async {
                      setState(() => loading = true);
                      try {
                        await context.read<TanksCubit>().createTankReading(
                              tankReading,
                              null,
                            );
                        setState(() => loading = false);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      } on Exception catch (e) {
                        if (context.mounted) {
                          showToast(context,
                              title: "Something went wrong.",
                              description: e.toString(),
                              toastType: ToastType.error);
                          setState(() => loading = false);
                        }
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
