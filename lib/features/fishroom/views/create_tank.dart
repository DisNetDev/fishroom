import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
  String _tankName = "";
  final String _tankType = "";
  String _tankSize = "";
  final String _measurementUnit = "L";
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  List<bool> tankTypeSelection = [false, false, false];
  List<bool> capacitySelection = [false, false, false, false];

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
                  _tankName = value;
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
                      _tankSize = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  label: const Text("Tank Capacity"),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  //TODO: Fill this up into the whole field somehow
                  child: ToggleButtons(
                      color: Colors.white,
                      borderColor: const Color.fromARGB(52, 255, 255, 255),
                      selectedColor: Colors.white,
                      selectedBorderColor: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      onPressed: (index) {
                        for (int i = 0; i < capacitySelection.length; i++) {
                          capacitySelection[i] = false;
                        }
                        setState(() {
                          capacitySelection[index] = true;
                        });
                      },
                      isSelected: capacitySelection,
                      children: const [
                        Text("L"),
                        Text("G"),
                        Text("F"),
                        Text("CM")
                      ]),
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
                    minHeight: 40,
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

                if (_tankName == "") {
                  tankNameFilled = false;
                  requiredFields += "Tank Name, ";
                }
                if (_tankSize == "") {
                  tankSizeFilled = false;
                  requiredFields += "Tank Size, ";
                }
                if (_tankType == "") {
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
                  context.read<TanksCubit>().addTank(Tank(
                      id: const Uuid().v4(),
                      name: _tankName,
                      type: _tankType,
                      size: _tankSize,
                      measurementUnit: _measurementUnit,
                      image: _image));
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
