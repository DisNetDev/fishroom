import 'package:fish_man/features/my_tanks/views/create_tank.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/root_appbar.dart';
import '../../../core/widgets/root_drawer.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/tank_tile.dart';

class MyTanks extends StatelessWidget {
  const MyTanks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const RootDrawer(),
      body: BlocBuilder<TanksCubit, TanksState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const RootSliverAppBar(
                title: "My Fish Room",
                sliver: true,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (state.tanks.isNotEmpty) {
                      return TankTile(tank: state.tanks[index]);
                    } else {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateTank()));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No Tanks Added",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic)),
                            Text("Tap to add a Tank and get started!",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic)),
                          ],
                        ),
                      );
                    }
                  },
                  childCount: state.tanks.isNotEmpty ? state.tanks.length : 1,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
