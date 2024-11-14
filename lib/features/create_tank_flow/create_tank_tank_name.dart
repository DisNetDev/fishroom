import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import 'create_tank_tank_size.dart';

class CreateTankTankName extends StatefulWidget {
  const CreateTankTankName({super.key});

  @override
  State<CreateTankTankName> createState() => _CreateTankTankNameState();
}

class _CreateTankTankNameState extends State<CreateTankTankName> {
  FocusNode nameFocusNode = FocusNode();
  Tank tank = Tank(id: const Uuid().v4());

  @override
  void initState() {
    nameFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const CustomBackground(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Lets create a tank!",
                  style: kHeadingTextStyle,
                  textAlign: TextAlign.center,
                ),
                const Gap(50),
                const Text(
                  "What would you like to name your new tank?",
                  style: kHeading2TextStyle,
                  textAlign: TextAlign.center,
                ),
                TextInput(
                    focusNode: nameFocusNode,
                    onEditingComplete: () => onComplete(),
                    onChanged: (p0) => setState(() => tank.name = p0)),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: CustomButton(
                  text: "Continue", onPressed: () => onComplete())),
        ],
      ),
    );
  }

  void onComplete() {
    if (tank.name?.isEmpty ?? true) {
      showToast(context,
          title: "Your tank needs a name!",
          description: 'Even if its just "Tank 1" ;)',
          toastType: ToastType.error);
      return;
    }
    nameFocusNode.unfocus();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CreateTankTankSize()));
  }
}
