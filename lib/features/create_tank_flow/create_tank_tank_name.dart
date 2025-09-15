import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import 'create_tank_tank_size.dart';

class CreateTankTankName extends StatefulWidget {
  const CreateTankTankName({super.key, this.tank});

  final Tank? tank;

  @override
  State<CreateTankTankName> createState() => _CreateTankTankNameState();
}

class _CreateTankTankNameState extends State<CreateTankTankName> {
  FocusNode nameFocusNode = FocusNode();
  Tank tank = Tank(id: const Uuid().v4());
  bool editTank = false;
  bool loading = false;

  @override
  void initState() {
    if (widget.tank == null) {
      nameFocusNode.requestFocus();
    }
    if (widget.tank != null) {
      tank = widget.tank!.copyWith();
      editTank = true;
    } else {
      if (context.read<AppCubit>().state.user != null) {
        tank.ownerId = context.read<AppCubit>().state.user!.uuid;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        editTank
                            ? "Editing your tank? Great!"
                            : context.read<TanksCubit>().state.tanks.isEmpty
                                ? "Welcome to Fishroom!\nLet's create your first tank!"
                                : "Woah! Another tank!\nLet's give it a name!",
                        style: kHeadingTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(50),
                      const Text(
                        "What would you like to name your new tank?",
                        style: kHeading2TextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(20),
                      TextInput(
                          initialValue: tank.name,
                          focusNode: nameFocusNode,
                          onEditingComplete: () => onComplete(),
                          onChanged: (p0) => setState(() => tank.name = p0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                          text: "Continue", onPressed: () => onComplete()),
                      Gap(20),
                      if (editTank)
                        CustomButton(
                          text: "Delete Tank",
                          onPressed: () {
                            _showDeleteConfirmationDialog(context);
                          },
                          loading: loading,
                          primary: false,
                          gradient: kErrorGradient,
                        ),
                      Gap(50)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Function to show a confirmation dialog for deleting a tank
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
              "Are you sure you want to delete this tank?\nThis cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                try {
                  context.read<TanksCubit>().deleteTank(tank);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  showToast(context,
                      title: "Something went wrong.",
                      toastType: ToastType.error,
                      description: e.toString());
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void onComplete() async {
    if (tank.name?.isEmpty ?? true) {
      showToast(context,
          title: "Your tank needs a name!",
          description: 'Even if its just "Tank 1" ;)',
          toastType: ToastType.error);

      return;
    }
    nameFocusNode.unfocus();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CreateTankTankSize(tank: tank, editTank: editTank)));
  }
}
