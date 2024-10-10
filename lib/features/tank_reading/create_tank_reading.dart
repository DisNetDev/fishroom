import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/models/tank_reading.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/root_appbar.dart';
import 'package:fishroom/features/fishroom/widgets/image_upload.dart';
import 'package:fishroom/features/tank_reading/usecases/parameters.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants.dart';
import '../../core/usecases/is_dark_mode.dart';
import '../../core/widgets/text_box.dart';
import 'widgets/parameter_wheel.dart';

class CreateTankReading extends StatefulWidget {
  const CreateTankReading({super.key, required this.tank});
  final Tank tank;

  @override
  State<CreateTankReading> createState() => _CreateTankReadingState();
}

class _CreateTankReadingState extends State<CreateTankReading> {
  late TankReading tankReading = TankReading(
      id: const Uuid().v4(),
      type: TankReadingType.measurement,
      tankId: widget.tank.id,
      createdAt: DateTime.now().toString(),
      note: "");
  List<bool> selectedTypeButtons = [true, false];

  double horizontalPadding = 12;

  @override
  Widget build(BuildContext context) {
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
          appBar: const RootSliverAppBar(title: "Add a Tank Reading"),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Gap(20),
                  Center(
                    child: ToggleButtons(
                        borderColor: isDarkMode(context)
                            ? Colors.blueGrey
                            : Colors.black26,
                        selectedBorderColor: kPrimaryColor,
                        constraints: BoxConstraints(
                            minHeight: 45,
                            minWidth: MediaQuery.of(context).size.width /
                                    selectedTypeButtons.length -
                                horizontalPadding -
                                2),
                        borderRadius: BorderRadius.circular(1000),
                        onPressed: (index) {
                          for (int i = 0; i < selectedTypeButtons.length; i++) {
                            selectedTypeButtons[i] = false;
                          }
                          setState(() {
                            selectedTypeButtons[index] = true;
                            if (selectedTypeButtons[0] == true) {
                              tankReading = tankReading.copyWith(
                                  type: TankReadingType.measurement);
                            } else {
                              tankReading = tankReading.copyWith(
                                  type: TankReadingType.note);
                            }
                          });
                        },
                        isSelected: selectedTypeButtons,
                        children: const [Text("Reading"), Text("Note")]),
                  ),
                  const Gap(20),
                  if (tankReading.type == TankReadingType.measurement)
                    readingWidget,
                  const Gap(20),
                  FishTextBox(
                    hintText: "Note",
                    onChanged: (value) => setState(
                        () => tankReading = tankReading.copyWith(note: value)),
                    initialValue: tankReading.note,
                  ),
                  const Gap(20),
                  ImageUpload(onTap: () {}),
                  const Gap(50),
                  CustomButton(text: "Save", onPressed: () {})
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget readingWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(readingParameters.length, (index) {
        return ParameterWheel(
            valueSelected: (value) {}, parameter: readingParameters[index]);
      }));
}
