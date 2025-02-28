import 'package:fishroom/core/usecases/nav_push.dart';
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

  @override
  void initState() {
    fertilizer = widget.fertilizer ??
        Fertilizer(name: "", dosage: "", perVolume: "", id: Uuid().v4());
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
            initialValue: fertilizer.name,
            label: Text("Fertilizer Name"),
            exampleText: "eg: Potassium",
            onChanged: (value) => setState(
              () => fertilizer = fertilizer.copyWith(name: value),
            ),
          ),
          Gap(40),
          Row(
            children: [
              Expanded(
                child: TextInput(
                  initialValue: fertilizer.dosage,
                  exampleText: "eg: 5ml",
                  label: Text("Dosage"),
                  onChanged: (value) => setState(
                    () => fertilizer = fertilizer.copyWith(dosage: value),
                  ),
                ),
              ),
              Text("per"),
              Expanded(
                child: TextInput(
                  initialValue: fertilizer.perVolume,
                  exampleText: "eg: 200L",
                  label: Text("Per Volume"),
                  onChanged: (value) => setState(
                    () => fertilizer = fertilizer.copyWith(perVolume: value),
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          CustomButton(
            onPressed: () {
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
