import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/custom_button.dart';
import '../models/fertilizer.dart';

class FertilizerModal extends StatefulWidget {
  const FertilizerModal({super.key, required this.onAdd});

  final Function(Fertilizer fertilizer) onAdd;

  @override
  State<FertilizerModal> createState() => _FertilizerModalState();
}

class _FertilizerModalState extends State<FertilizerModal> {
  Fertilizer fertilizer =
      Fertilizer(name: "", dosage: "", perVolume: "", id: Uuid().v4());

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
            text: "Add Fertilizer",
          ),
          Gap(40),
        ],
      ),
    );
  }
}
