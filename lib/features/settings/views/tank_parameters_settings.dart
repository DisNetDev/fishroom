import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/features/settings/usecases/are_parameters_edited.dart';
import 'package:fishroom/features/settings/widgets.dart/add_tank_parameter.dart';
import 'package:fishroom/features/settings/widgets.dart/parameter_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/usecases/is_dark_mode.dart';
import '../../app/cubit/app_cubit.dart';
import '../../tank_reading/models/parameter.dart';

class TankParametersSettings extends StatefulWidget {
  const TankParametersSettings({super.key});

  @override
  State<TankParametersSettings> createState() => _TankParametersSettingsState();
}

class _TankParametersSettingsState extends State<TankParametersSettings> {
  bool resettingDefaults = false;
  List<Parameter> parameters = [];
  bool loading = false;

  @override
  void initState() {
    parameters.addAll(context.read<AppCubit>().state.settings.parameters ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool edited = areParametersEdited(
        parameters, context.read<AppCubit>().state.settings.parameters ?? []);

    return Scaffold(
      floatingActionButton: !edited
          ? null
          : FloatingActionButton.extended(
              label: loading
                  ? Loader(
                      color: isDarkMode(context) ? Colors.black : Colors.white,
                    )
                  : const Text(
                      "Save",
                    ),
              icon: loading ? null : const Icon(Symbols.save),
              onPressed: () async {
                if (loading) return;
                try {
                  setState(() => loading = true);
                  await context.read<AppCubit>().updateSettings(context
                      .read<AppCubit>()
                      .state
                      .settings
                      .copyWith(parameters: parameters));
                  setState(() => loading = false);
                  Navigator.of(context).pop();
                } catch (e) {
                  setState(() => loading = false);

                  // ignore: use_build_context_synchronously
                  showToast(context,
                      title: "Something went wrong.",
                      toastType: ToastType.error,
                      description: e.toString());
                }
              },
            ),
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Gap(80),
                      Text(
                        "Which water parameters do you normally test?",
                        textAlign: TextAlign.center,
                        style: kHeadingTextStyle.copyWith(fontSize: 24),
                      ),
                      const Gap(40),
                      ...List.generate(
                        parameters.length,
                        (index) => ParameterListWidget(
                          parameter: parameters[index],
                          onDismissed: () {
                            setState(() => parameters.removeAt(index));
                          },
                          onEdit: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditParameter(
                                    onParameterAdded: (parameter) {
                                      setState(
                                          () => parameters[index] = parameter);
                                    },
                                    parameter: parameters[index])));
                          },
                        ),
                      ),
                      if (parameters.isNotEmpty)
                        Text(
                          "<- Swipe to remove",
                          style:
                              kDateTimeTextStyle.copyWith(color: Colors.grey),
                          textAlign: TextAlign.right,
                        ),
                      const Gap(20),
                      AddTankParameter(
                        onParameterAdded: (parameter) =>
                            setState(() => parameters.add(parameter)),
                      ),
                      const Gap(40),
                      CustomButton(
                          text: "Reset to Defaults",
                          loading: resettingDefaults,
                          primary: false,
                          onPressed: () async {
                            if (resettingDefaults) return;

                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                      "Are you sure you want to reset to defaults?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmed == false || confirmed == null) return;

                            try {
                              setState(() => resettingDefaults = true);
                              if (context.mounted) {
                                List<Parameter> fetchedParameters =
                                    await context
                                        .read<AppCubit>()
                                        .setParametersDefaults();
                                setState(() => parameters = fetchedParameters);
                              }
                              setState(() => resettingDefaults = false);
                            } on Exception catch (e) {
                              setState(() => resettingDefaults = false);
                              if (context.mounted) {
                                showToast(context,
                                    title:
                                        "Something went wrong setting defaults",
                                    description: e.toString(),
                                    toastType: ToastType.error);
                              }
                            }
                          }),
                      const Gap(80),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
