import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/fertilizers/usecases/are_fertilizers_edited.dart';
import 'package:fishroom/features/fertilizers/widgets/fertilizer_settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/widgets/loader.dart';
import '../../app/cubit/app_cubit.dart';
import '../models/fertilizer.dart';
import '../usecases/show_fertilizer_modal.dart';

class FertilizerSettings extends StatefulWidget {
  const FertilizerSettings({super.key});

  @override
  State<FertilizerSettings> createState() => _FertilizerSettingsState();
}

class _FertilizerSettingsState extends State<FertilizerSettings> {
  AppCubit get cubit => context.read<AppCubit>();

  List<Fertilizer> fertilizers = [];

  bool edited = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fertilizers.addAll(cubit.state.settings.fertilizers);
  }

  @override
  Widget build(BuildContext context) {
    if (!edited) {
      edited =
          areFertilizersEdited(fertilizers, cubit.state.settings.fertilizers);
    }

    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          floatingActionButton: !edited
              ? null
              : FloatingActionButton.extended(
                  label: loading
                      ? Loader(
                          color:
                              isDarkMode(context) ? Colors.black : Colors.white,
                        )
                      : const Text(
                          "Save",
                        ),
                  icon: loading ? null : const Icon(Symbols.save),
                  onPressed: () async {
                    if (loading) return;
                    setState(() => loading = true);
                    try {
                      await cubit.updateSettings(cubit.state.settings
                          .copyWith(fertilizers: fertilizers));
                      setState(() => loading = false);
                      navPop(context);
                    } catch (e) {
                      setState(() => loading = false);
                    }
                  },
                ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gap(40),
                    Text("Set your fertilizers and dosages.",
                        style: kHeadingTextStyle, textAlign: TextAlign.center),
                    Gap(40),
                    for (Fertilizer fertilizer in fertilizers)
                      FertilizerSettingsWidget(
                        fertilizer: fertilizer,
                        onTap: () => showFertilizerModal(
                          context,
                          fertilizer: fertilizer,
                          onAdd: _onAddFertilizer,
                        ),
                        onDismissed: () => _onRemovedFertilizer(fertilizer),
                      ),
                    Gap(40),
                    GestureDetector(
                      onTap: () {
                        showFertilizerModal(
                          context,
                          onAdd: _onAddFertilizer,
                        );
                      },
                      child: NeoBruteBorder(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          child: Text("Add Fertilizer"),
                        ),
                      ),
                    ),
                    Gap(100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _onRemovedFertilizer(Fertilizer fertilizer) {
    setState(() {
      fertilizers.removeWhere((element) => element.id == fertilizer.id);
    });
  }

  _onAddFertilizer(fertilizer) {
    setState(() {
      int indexOf =
          fertilizers.indexWhere((element) => element.id == fertilizer.id);
      if (indexOf != -1) {
        fertilizers[indexOf] = fertilizer;
      } else {
        fertilizers.add(fertilizer);
      }
    });
  }
}
