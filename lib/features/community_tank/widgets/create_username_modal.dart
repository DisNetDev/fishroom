import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'dart:async';

import '../../../core/constants.dart';
import '../../../core/usecases/show_toast.dart';
import '../../app/cubit/app_cubit.dart';

class CreateUsernameModal extends StatefulWidget {
  const CreateUsernameModal({super.key});

  @override
  State<CreateUsernameModal> createState() => _CreateUsernameModalState();
}

class _CreateUsernameModalState extends State<CreateUsernameModal> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  AppCubit get appCubit => context.read<AppCubit>();

  Future<void> checkUsernameExists(String username) async {
    if (username.isEmpty) {
      setState(() => isUsernameValid = false);
      return;
    }

    setState(() => checkUsernameLoading = true);
    try {
      final response = await appCubit.checkUsernameExists(username);
      setState(() {
        checkUsernameLoading = false;
        isUsernameValid = !response;
      });
    } catch (e) {
      setState(() => checkUsernameLoading = false);
      showToast(context,
          title: "Error checking username.",
          description: e.toString(),
          toastType: ToastType.error);
    }
  }

  String username = "";
  bool isLoading = false;
  bool isUsernameValid = false;
  bool checkUsernameLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            Text("Welcome to the Community Tank!", style: kHeadingTextStyle),
            const Gap(10),
            Text("Create a username to get started", style: kHeading1TextStyle),
            const Gap(40),
            TextInput(
              suffix: checkUsernameLoading ? const Loader(height: 15) : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Username cannot be empty";
                }
                if (value.length > 15) {
                  return "Username must be less than 15 characters long";
                }
                if (value.contains(" ")) {
                  return "Username cannot contain spaces";
                }
                if (!isUsernameValid) {
                  return "Username is already taken";
                }
                return null;
              },
              label: const Text("Username"),
              onChanged: (value) {
                setState(() => username = value);
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 200), () {
                  checkUsernameExists(value);
                });
              },
            ),
            Expanded(child: SizedBox()),
            CustomButton(
              text: "Create Username",
              loading: isLoading,
              onPressed: () async {
                setState(() => isLoading = true);
                try {
                  await appCubit.createUsername(username);
                  setState(() => isLoading = false);
                } catch (e) {
                  setState(() => isLoading = false);
                  showToast(context,
                      title: "Error creating username",
                      description: e.toString(),
                      toastType: ToastType.error);
                }
              },
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}
