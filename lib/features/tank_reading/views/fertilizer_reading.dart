import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/models/tank_reading.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/fertilizers/models/fertilizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../../core/usecases/show_toast.dart';
import '../../../core/widgets/custom_button.dart';
import '../../app/cubit/app_cubit.dart';
import '../../fishroom/cubit/tanks_cubit.dart';
import '../models/dosage.dart';
import '../widgets/dosage_widget.dart';

class FertilizerReading extends StatefulWidget {
  const FertilizerReading({super.key, required this.tank});

  final Tank tank;

  @override
  State<FertilizerReading> createState() => _FertilizerReadingState();
}

class _FertilizerReadingState extends State<FertilizerReading> {
  bool loading = false;
  List<Fertilizer> get fertilizers =>
      context.read<AppCubit>().state.settings.fertilizers;

  late TankReading reading = TankReading(
    id: Uuid().v4(),
    type: TankReadingType.fertilize,
    ownerId: context.read<AppCubit>().state.user!.uuid,
    tankId: widget.tank.id,
    createdAt: DateTime.now().toString(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          appBar: RootSliverAppBar(
            title: "Fertilizer Dose",
            implyLeading: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Give those plants some food! Add a fertilizer dose.",
                    style: kHeadingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap(20),
                for (Fertilizer fertilizer in fertilizers)
                  DosageWidget(
                    onTap: () {
                      setState(() {
                        if (reading.dosages.any(
                            (test) => test.fertilizer.id == fertilizer.id)) {
                          reading.dosages.removeWhere(
                              (test) => test.fertilizer.id == fertilizer.id);
                        } else {
                          reading.dosages.add(
                            Dosage(
                              amount: null,
                              fertilizer: fertilizer,
                            ),
                          );
                        }
                      });
                    },
                    fertilizer: fertilizer,
                    enabled: reading.dosages
                        .any((test) => test.fertilizer.id == fertilizer.id),
                    onChanged: (p0) => setState(
                      () {
                        if (p0.isEmpty) {
                          reading.dosages.removeWhere(
                              (test) => test.fertilizer.id == fertilizer.id);

                          return;
                        }
                        int indexOf = reading.dosages.indexWhere(
                            (test) => test.fertilizer.id == fertilizer.id);
                        if (indexOf == -1) {
                          reading.dosages.add(
                            Dosage(
                              amount: double.tryParse(p0),
                              fertilizer: fertilizer,
                            ),
                          );
                        } else {
                          reading.dosages[indexOf] = reading.dosages[indexOf]
                              .copyWith(amount: double.tryParse(p0));
                        }
                      },
                    ),
                  ),
                Gap(40),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    text: "Create Reading",
                    loading: loading,
                    onPressed: () async {
                      if (reading.dosages.isEmpty) {
                        showToast(context,
                            title: "No dosages added",
                            description:
                                "Please add at least one dosage to continue.",
                            toastType: ToastType.error);

                        return;
                      }
                      if (reading.dosages.any(
                          (test) => test.amount == null || test.amount! <= 0)) {
                        showToast(context,
                            title: "Invalid dosage",
                            description:
                                "Please enter a valid number for all dosages.",
                            toastType: ToastType.error);

                        return;
                      }
                      try {
                        setState(() => loading = true);
                        await context
                            .read<TanksCubit>()
                            .createTankReading(reading, null);
                        setState(() => loading = false);

                        navPop(context);
                        navPop(context);
                      } catch (e) {
                        setState(() => loading = false);
                        showToast(context,
                            title: "Something went wrong",
                            description: e.toString(),
                            toastType: ToastType.error);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
