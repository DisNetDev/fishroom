import 'package:collection/collection.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:fishroom/features/tank_inhabitants/views/add_inhabitants_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/models/tank.dart';
import '../../../core/usecases/nav_push.dart';
import '../../../core/usecases/show_toast.dart';
import '../models/inhabitant.dart';
import '../widgets/inhabitant_widget.dart';

class TankInhabitants extends StatefulWidget {
  const TankInhabitants({super.key, required this.tank});

  final Tank tank;

  @override
  State<TankInhabitants> createState() => _TankInhabitantsState();
}

class _TankInhabitantsState extends State<TankInhabitants> {
  Tank get _tank =>
      tanksCubit.state.tanks
          .firstWhereOrNull((test) => test.id == widget.tank.id) ??
      widget.tank;
  TanksCubit get tanksCubit => context.read<TanksCubit>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                navPush(
                    context,
                    AddInhabitantsView(
                        tank: _tank, chosenInhabitant: _addInhabitant));
              },
              child: Icon(Icons.add),
            ),
            backgroundColor: Colors.transparent,
            appBar: RootSliverAppBar(
              title: "Inhabitants",
              implyLeading: true,
            ),
            body: SingleChildScrollView(
              child: BlocBuilder<TanksCubit, TanksState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Gap(20),
                      ...List.generate(
                        _tank.inhabitants.length,
                        (index) => Animate(
                          effects: [
                            SlideEffect(
                              curve: Curves.ease,
                              delay: Duration(milliseconds: 100 * index),
                              begin: Offset(1, 0),
                            )
                          ],
                          child: InhabitantWidget(
                            inhabitant: _tank.inhabitants[index],
                            onAdd: _addInhabitant,
                          ),
                        ),
                      ),
                      Gap(20),
                    ],
                  );
                },
              ),
            )),
      ],
    );
  }

  void _addInhabitant(Inhabitant inhabitant) async {
    Tank tank = _tank.copyWith(
      inhabitants: [
        inhabitant,
        ..._tank.inhabitants.where(
            (existingInhabitant) => existingInhabitant.id != inhabitant.id),
      ],
    );
    tank.inhabitants.removeWhere((inhabitant) => inhabitant.count == 0);

    try {
      await tanksCubit.updateTankInhabitants(tank.id, tank.inhabitants);
    } catch (e) {
      showToast(context,
          title: "Error adding inhabitant...",
          description: e.toString(),
          toastType: ToastType.error);
    }
  }
}
