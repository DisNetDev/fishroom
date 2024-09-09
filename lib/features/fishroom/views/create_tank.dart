import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/fishy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/tank.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/root_appbar.dart';
import '../../../core/widgets/text_input.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/image_upload.dart';

class CreateTank extends StatefulWidget {
  const CreateTank({super.key});

  @override
  State<CreateTank> createState() => _CreateTankState();
}

class _CreateTankState extends State<CreateTank> {
  Tank tank = Tank(
    id: const Uuid().v4(),
  );
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  List<bool> tankTypeSelection = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RootSliverAppBar(title: "Create a Tank"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextInput(
              margin: const EdgeInsets.symmetric(vertical: 16),
              label: const Text("Tank Name"),
              onChanged: (value) {
                setState(() {
                  tank.name = value;
                });
              },
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextInput(
                  margin: const EdgeInsets.all(0),
                  onChanged: (value) {
                    setState(() {
                      tank.size = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  label: const Text("Tank Capacity"),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _CapacityButton(
                        measurementUnit: "L",
                        isSelected: tank.measurementUnit == "L",
                        onTap: () {
                          setState(
                            () {
                              tank.measurementUnit = "L";
                            },
                          );
                        },
                      ),
                      _CapacityButton(
                        measurementUnit: "Gal",
                        isSelected: tank.measurementUnit == "Gal",
                        onTap: () {
                          setState(
                            () {
                              tank.measurementUnit = "Gal";
                            },
                          );
                        },
                      ),
                      _CapacityButton(
                        measurementUnit: "ft",
                        isSelected: tank.measurementUnit == "ft",
                        onTap: () {
                          setState(
                            () {
                              tank.measurementUnit = "ft";
                            },
                          );
                        },
                      ),
                      _CapacityButton(
                        measurementUnit: "cm",
                        isSelected: tank.measurementUnit == "cm",
                        onTap: () {
                          setState(
                            () {
                              tank.measurementUnit = "cm";
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(1000),
              ),
              child: ToggleButtons(
                borderColor: Colors.black26,
                selectedBorderColor: Colors.transparent,
                constraints: BoxConstraints(
                    minHeight: 45,
                    minWidth: MediaQuery.of(context).size.width /
                            tankTypeSelection.length -
                        12),
                borderRadius: BorderRadius.circular(1000),
                onPressed: (index) {
                  for (int i = 0; i < tankTypeSelection.length; i++) {
                    tankTypeSelection[i] = false;
                  }
                  setState(() {
                    tankTypeSelection[index] = true;
                    tank.type = index == 0
                        ? "Freshwater"
                        : index == 1
                            ? "Saltwater"
                            : "Brackish";
                  });
                },
                isSelected: tankTypeSelection,
                children: const [
                  Text("Freshwater"),
                  Text("Saltwater"),
                  Text("Brackish"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ImageUpload(
              image: _image,
              onTap: () async {
                final XFile? image =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _image = image;
                });
              },
            ),
            const Expanded(
              child: SizedBox(),
            ),
            CustomButton(
              margin: const EdgeInsets.symmetric(vertical: 16),
              text: "Create",
              onPressed: () {
                bool tankNameFilled = true;
                bool tankSizeFilled = true;
                bool tankTypeFilled = true;
                String requiredFields = "";

                if (tank.name == "") {
                  tankNameFilled = false;
                  requiredFields += "Tank Name, ";
                }
                if (tank.size == "") {
                  tankSizeFilled = false;
                  requiredFields += "Tank Size, ";
                }
                if (tank.type == "") {
                  tankTypeFilled = false;
                  requiredFields += "Tank Type, ";
                }

                if (!tankSizeFilled || !tankTypeFilled || !tankNameFilled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    fishySnackBar(
                      title: "Missing Information",
                      message:
                          "Missing Info: \n${requiredFields.substring(0, requiredFields.length - 2)}.",
                      contentType: ContentType.warning,
                    ),
                  );
                } else {
                  tank.image = _image;
                  context.read<TanksCubit>().addTank(tank);
                  ScaffoldMessenger.of(context).showSnackBar(fishySnackBar(
                      title: "Tank Created",
                      message: "Tank created successfully",
                      contentType: ContentType.success,
                      color: const Color.fromARGB(255, 0, 156, 21)));
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CapacityButton extends StatelessWidget {
  const _CapacityButton({
    required this.measurementUnit,
    required this.isSelected,
    required this.onTap,
  });

  final String measurementUnit;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(),
        child: Text(measurementUnit,
            style: TextStyle(
              color: isSelected ? kPrimaryColor : Colors.white30,
            )),
      ),
    );
  }
}
