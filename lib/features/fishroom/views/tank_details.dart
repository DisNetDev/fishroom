import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/root_appbar.dart';
import 'package:fishroom/features/tank_reading/create_tank_reading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/tank_entry_list_item.dart';

class TankDetails extends StatefulWidget {
  const TankDetails({super.key, required this.tank});

  final Tank tank;

  @override
  State<TankDetails> createState() => _TankDetailsState();
}

class _TankDetailsState extends State<TankDetails> {
  bool loading = false;

  Future<void> getTankReadings() async {
    setState(() => loading = true);
    await context.read<TanksCubit>().getReadingsForTank(widget.tank);
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    getTankReadings();
  }

  // Function to show a confirmation dialog for deleting a tank
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this tank?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                try {
                  context.read<TanksCubit>().deleteTank(widget.tank);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  showToast(context,
                      title: "Something went wrong.",
                      toastType: ToastType.error,
                      description: e.toString());
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TankReading> readings = context
        .read<TanksCubit>()
        .state
        .readings
        .where((reading) => reading.tankId == widget.tank.id)
        .toList();

    String tankTypeNonNullable = widget.tank.type ?? "Tank Type";
    if (tankTypeNonNullable == "") {
      tankTypeNonNullable = "Tank Type";
    }
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: isDarkMode(context)
                      ? const AssetImage("assets/background_dark.png")
                      : const AssetImage("assets/background_light.png"))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Positioned(
          bottom: 0,
          child: Opacity(
            opacity: isDarkMode(context) ? 0.05 : 0.1,
            child: Image(
              image: const AssetImage(
                "assets/bottom_decoration.png",
              ),
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateTankReading(
                            tank: widget.tank,
                          )));
            },
            child: const Icon(Icons.add),
          ),
          appBar: RootSliverAppBar(
            title: widget.tank.name ?? "Tank Details",
            actions: [
              IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    if (loading)
                      for (var i = 0; i < 4; i++)
                        Skeletonizer(
                            child: TankEntryListItem(
                                reading: TankReading(
                                    id: "aaa",
                                    type: TankReadingType.measurement,
                                    tankId: widget.tank.id,
                                    createdAt: DateTime.now().toString(),
                                    note: "Some Dummy Info"))),
                    ...List.generate(
                      readings.length,
                      (index) {
                        return TankEntryListItem(reading: readings[index]);
                      },
                    ),
                    const Gap(300),
                  ],
                ),
                Positioned(
                  bottom: -20,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 3 * 1,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.tank.imageUrl ?? "",
                        errorWidget: (context, url, error) => const SizedBox(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                          Colors.transparent
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            widget.tank.name ?? "Tank name not found",
                            style: kHeading1TextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            "$tankTypeNonNullable - ${widget.tank.size}${widget.tank.measurementUnit}",
                            style: kHeading2TextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
