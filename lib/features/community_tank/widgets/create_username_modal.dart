import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/constants.dart';
import '../../app/cubit/app_cubit.dart';

class CreateUsernameModal extends StatefulWidget {
  const CreateUsernameModal({super.key});

  @override
  State<CreateUsernameModal> createState() => _CreateUsernameModalState();
}

class _CreateUsernameModalState extends State<CreateUsernameModal> {
  AppCubit get appCubit => context.read<AppCubit>();

  String username = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SizedBox()),
          Text("Create Username", style: kHeadingTextStyle),
          const Gap(20),
          Text(
            "We do not have a username for you. Please create one.",
            style: kHeading1TextStyle,
            textAlign: TextAlign.center,
          ),
          const Gap(40),
          TextInput(
            label: const Text("Username"),
            onChanged: (value) {
              setState(() => username = value);
            },
          ),
          Expanded(child: SizedBox()),
          CustomButton(
            text: "Create Username",
            onPressed: () {},
          ),
          const Gap(40),
        ],
      ),
    );
  }
}
