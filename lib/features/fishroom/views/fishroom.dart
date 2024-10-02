import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/features/fishroom/views/create_tank.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/tank.dart';
import '../../../core/widgets/root_appbar.dart';
import '../../../core/widgets/root_drawer.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/tank_tile.dart';

class Fishroom extends StatefulWidget {
  const Fishroom({super.key});

  @override
  State<Fishroom> createState() => _FishroomState();
}

class _FishroomState extends State<Fishroom> {
  bool loading = false;

  init() async {
    if (context.read<TanksCubit>().state.tanks.isEmpty) {
      setState(() => loading = true);
      try {
        await context.read<TanksCubit>().getTanks();
      } on Exception catch (e) {
        showToast(
            title: "Something went wrong.",
            description: e.toString(),
            type: ToastificationType.error);
      }
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TanksCubit, TanksState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateTank()));
            },
            child: const Icon(Icons.add),
          ),
          appBar: state.tanks.isEmpty || loading
              ? const RootSliverAppBar(
                  implyLeading: false,
                  title: "Fishroom",
                )
              : null,
          endDrawer: const RootDrawer(),
          body: Builder(
            builder: (context) {
              if (loading) {
                return Column(
                  children: [
                    Skeletonizer(
                        child: Skeleton.shade(
                            child: TankTile(tank: Tank(id: const Uuid().v4()))))
                  ],
                );
              }
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
