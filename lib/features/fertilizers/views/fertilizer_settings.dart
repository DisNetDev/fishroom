import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../app/cubit/app_cubit.dart';
import '../models/fertilizer.dart';
import '../widgets/fertilizer_modal.dart';

class FertilizerSettings extends StatefulWidget {
  const FertilizerSettings({super.key});

  @override
  State<FertilizerSettings> createState() => _FertilizerSettingsState();
}

class _FertilizerSettingsState extends State<FertilizerSettings> {
  AppCubit get cubit => context.read<AppCubit>();

  List<Fertilizer> fertilizers = [];

  @override
  void initState() {
    super.initState();
    fertilizers.addAll(cubit.state.settings.fertilizers);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: RootSliverAppBar(
            implyLeading: true,
            title: "Fertilizer Settings",
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(40),
                Text("Set your fertilizers and dosages.",
                    style: kHeadingTextStyle, textAlign: TextAlign.center),
                for (Fertilizer fertilizer in fertilizers)
                  ListTile(
                    title: Text(fertilizer.name),
                    subtitle: Text(fertilizer.dosage),
                  ),
                Gap(40),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => FertilizerModal(
                        onAdd: (fertilizer) {
                          setState(() => fertilizers.add(fertilizer));
                        },
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: GradientBoxBorder(gradient: kPrimaryGradient)),
                    child: Text("Add Fertilizer"),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
