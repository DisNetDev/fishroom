import 'package:fishroom/features/fishroom/views/create_tank.dart';
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
    return BlocBuilder<TanksCubit, TanksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.tanks.isEmpty
              ? const RootSliverAppBar(
                  title: "Fishroom",
                )
              : null,
          endDrawer: const RootDrawer(),
          body: Builder(
            builder: (context) {
              if (state.tanks.isNotEmpty) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const RootSliverAppBar(
                      title: "Fishroom",
                      sliver: true,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return TankTile(tank: state.tanks[index]);
                        },
                        childCount:
                            state.tanks.isNotEmpty ? state.tanks.length : 1,
                      ),
                    ),
                  ],
                );
              } else {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateTank()));
                  },
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No Tanks Added",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      Text("Tap to add a Tank and get started!",
                          textAlign: TextAlign.center,
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
          ),
        );
      },
    );
  }
}
