import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fish_room/core/widgets/fishy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/tank.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_dropdown.dart';
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
  String _tankType = "";
  String _tankSize = "";
  String _measurementUnit = "L";
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

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
              hintText: "Tank Name",
              onChanged: (value) {
                setState(() {
                  _tankName = value;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextInput(
                    margin: const EdgeInsets.all(0),
                    onChanged: (value) {
                      setState(() {
                        _tankSize = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    hintText: "Tank Capacity",
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          if (_measurementUnit == "L") {
                            _measurementUnit = "G";
                          } else {
                            _measurementUnit = "L";
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          _measurementUnit,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                CustomDropdown(
                  margin: const EdgeInsets.only(left: 16),
                  hintText: "Tank Type",
                  entries: const [
                    DropdownMenuEntry(value: "Freshwater", label: "Freshwater"),
                    DropdownMenuEntry(value: "Brackish", label: "Brackish"),
                    DropdownMenuEntry(value: "Saltwater", label: "Saltwater"),
                  ],
                  onSelected: (value) {
                    setState(() {
                      _tankType = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
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
            const Expanded(child: SizedBox()),
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
