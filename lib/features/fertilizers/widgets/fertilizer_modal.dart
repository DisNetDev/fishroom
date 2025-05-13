import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/custom_button.dart';
import '../models/fertilizer.dart';

class FertilizerModal extends StatefulWidget {
  const FertilizerModal({super.key, required this.onAdd, this.fertilizer});

  final Function(Fertilizer fertilizer) onAdd;
  final Fertilizer? fertilizer;

  @override
  State<FertilizerModal> createState() => _FertilizerModalState();
}

class _FertilizerModalState extends State<FertilizerModal> {
  late Fertilizer fertilizer;

  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController perVolumeController = TextEditingController();

  List<String> dosageUnits = ["ml", "g", "drops"];
  List<String> perVolumeUnits = ["L", "ml", "gal"];

  @override
  void initState() {
    nameController.text = widget.fertilizer?.name ?? "";
    dosageController.text = widget.fertilizer?.dosage.toString() ?? "";
    perVolumeController.text = widget.fertilizer?.perVolume.toString() ?? "";

    fertilizer = widget.fertilizer ??
        Fertilizer(
            name: "",
            dosage: 0,
            perVolume: 0,
            id: Uuid().v4(),
            dosageUnit: dosageUnits.first,
            perVolumeUnit: perVolumeUnits.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Gap(10),
          TextInput(
            validator: (value) => value.isEmpty ? "Please enter a name" : null,
            controller: nameController,
            label: Text("Fertilizer Name"),
            exampleText: "eg: Potassium",
            onChanged: (value) => setState(
              () => fertilizer = fertilizer.copyWith(name: value),
            ),
          ),
          Gap(40),
          Text("Recommended Dosage:"),
          Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: TextInput(
                controller: dosageController,
                label: Text("Dosage"),
                exampleText: "eg: 5ml",
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => fertilizer =
                    fertilizer.copyWith(dosage: double.tryParse(value))),
                onTap: () {
                  if (dosageController.text == "0") {
                    dosageController.clear();
                  }
                },
                validator: (value) => double.tryParse(value) == null
                    ? "Please enter a valid number, avoid commas, use dots"
                    : null,
              )),
              NeoBruteBorder(
                showBorder: false,
                child: DropdownMenu(
                  initialSelection: fertilizer.dosageUnit == ""
                      ? dosageUnits.first
                      : fertilizer.dosageUnit,
                  label: Text("Unit"),
                  onSelected: (value) => setState(() =>
                      fertilizer = fertilizer.copyWith(dosageUnit: value)),
                  dropdownMenuEntries: dosageUnits
                      .map(
                        (e) => DropdownMenuEntry(
                          label: e,
                          value: e,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          Gap(40),
          Text("Per Volume of Water:"),
          Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: TextInput(
                label: Text("per Volume"),
                exampleText: "eg: 100L",
                keyboardType: TextInputType.number,
                controller: perVolumeController,
                onChanged: (value) => setState(() => fertilizer =
                    fertilizer.copyWith(perVolume: double.tryParse(value))),
                onTap: () {
                  if (perVolumeController.text == "0") {
                    perVolumeController.clear();
                  }
                },
                validator: (value) => double.tryParse(value) == null
                    ? "Please enter a valid number, avoid commas, use dots"
                    : null,
              )),
              NeoBruteBorder(
                showBorder: false,
                child: DropdownMenu(
                  initialSelection: fertilizer.perVolumeUnit == ""
                      ? perVolumeUnits.first
                      : fertilizer.perVolumeUnit,
                  label: Text("Unit"),
                  onSelected: (value) => setState(() =>
                      fertilizer = fertilizer.copyWith(perVolumeUnit: value)),
                  dropdownMenuEntries: perVolumeUnits
                      .map(
                        (e) => DropdownMenuEntry(
                          label: e,
                          value: e,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          CustomButton(
            onPressed: () {
              if (nameController.text.isEmpty) {
                showToast(context,
                    title: "Name field is required",
                    toastType: ToastType.error);

                return;
              }
              if (dosageController.text.isEmpty) {
                showToast(context,
                    title: "Dosage field is required",
                    toastType: ToastType.error);

                return;
              }
              if (perVolumeController.text.isEmpty) {
                showToast(context,
                    title: "Per Volume field is required",
                    toastType: ToastType.error);

                return;
              }

              widget.onAdd(fertilizer);
              navPop(context);
            },
            text: widget.fertilizer != null
                ? "Edit Fertilizer"
                : "Add Fertilizer",
          ),
          Gap(40),
        ],
      ),
    );
  }
}
