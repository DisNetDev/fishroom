import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/models/tank_reading.dart';
import 'package:fishroom/core/usecases/dialog_show.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:fishroom/features/tank_reading/views/create_tank_note.dart';
import 'package:fishroom/features/tank_reading/views/create_tank_reading.dart';
import 'package:fishroom/features/tank_reading/views/fertilizer_reading.dart';
import 'package:fishroom/features/tank_reading/views/water_change_reading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/tank.dart';

class SelectReadingType extends StatefulWidget {
  const SelectReadingType({super.key, required this.tank});

  final Tank tank;

  @override
  State<SelectReadingType> createState() => _SelectReadingTypeState();
}

class _SelectReadingTypeState extends State<SelectReadingType> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomBackground(),
          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: _isLoading
                    ? Loader()
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "What type of entry would you like to make?",
                                textAlign: TextAlign.center,
                                style: kHeadingTextStyle,
                              ),
                            ),
                            Gap(20),
                            _ItemList(
                                tank: widget.tank,
                                title: "Parameter Reading",
                                subtitle:
                                    "Log a reading of the tank's parameters.",
                                onTap: () {
                                  navPush(context,
                                      CreateTankReading(tank: widget.tank));
                                }),
                            _ItemList(
                                tank: widget.tank,
                                title: "Note",
                                subtitle: "Log a note about the tank.",
                                subsubtitle:
                                    "Not counted towards the 'The Abandoned' achievement.",
                                onTap: () {
                                  navPush(context,
                                      CreateTankNote(tank: widget.tank));
                                }),
                            _ItemList(
                                tank: widget.tank,
                                title: "Water Change",
                                subtitle: "Log a water change.",
                                onTap: () {
                                  navPush(context,
                                      WaterChangeReading(tank: widget.tank));
                                }),
                            _ItemList(
                                tank: widget.tank,
                                title: "Fertilizer Dose",
                                subtitle: "Log a fertilizer dose.",
                                onTap: () {
                                  navPush(context,
                                      FertilizerReading(tank: widget.tank));
                                }),
                            _ItemList(
                              tank: widget.tank,
                              title: "Feeding",
                              subtitle: "Log a feeding.",
                              onTap: () async {
                                final result = await dialogShow(
                                    context,
                                    "Feeding",
                                    "Are you sure you want to log a feeding?");
                                if (result == true) {
                                  setState(() => _isLoading = true);
                                  try {
                                    TankReading reading = TankReading(
                                      id: Uuid().v4(),
                                      ownerId: context
                                          .read<AppCubit>()
                                          .state
                                          .user!
                                          .uuid,
                                      tankId: widget.tank.id,
                                      type: TankReadingType.feed,
                                      createdAt: DateTime.now().toString(),
                                    );

                                    await context
                                        .read<TanksCubit>()
                                        .createTankReading(reading, null);

                                    navPop(context);
                                    setState(() => _isLoading = false);
                                  } catch (e) {
                                    setState(() => _isLoading = false);
                                    showToast(context,
                                        title: "Error",
                                        description: e.toString(),
                                        toastType: ToastType.error);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({
    required this.tank,
    required this.title,
    required this.subtitle,
    this.subsubtitle,
    required this.onTap,
  });

  final Tank tank;
  final String title;
  final String subtitle;
  final String? subsubtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: NeoBruteBorder(
        child: ListTile(
          title: Text(
            title,
            style: kHeading1TextStyle,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: kHeading2TextStyle,
              ),
              if (subsubtitle != null) Gap(5),
              if (subsubtitle != null)
                Text(
                  subsubtitle!,
                  style: kDateTimeTextStyle,
                ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
