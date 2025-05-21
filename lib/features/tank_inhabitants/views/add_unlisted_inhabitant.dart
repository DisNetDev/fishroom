import 'dart:io';

import 'package:fishroom/core/usecases/dialog_show.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/fishroom/widgets/image_upload_widget.dart';
import 'package:fishroom/features/tank_inhabitants/cubit/inhabitants_cubit.dart';
import 'package:fishroom/features/tank_inhabitants/models/inhabitant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

class AddUnlistedInhabitant extends StatefulWidget {
  const AddUnlistedInhabitant({super.key, required this.onInhabitantAdded});
  final Function(Inhabitant) onInhabitantAdded;

  @override
  State<AddUnlistedInhabitant> createState() => _AddUnlistedInhabitantState();
}

class _AddUnlistedInhabitantState extends State<AddUnlistedInhabitant> {
  bool loading = false;

  Inhabitant inhabitant = Inhabitant(
    id: Uuid().v4(),
    scientificName: "",
  );
  File? image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: RootSliverAppBar(title: "Add Unlisted Inhabitant"),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextInput(
                    label: Text("Common Name"),
                    onChanged: (value) =>
                        setState(() => inhabitant.commonName = value),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return "Common name is required";
                      }

                      return null;
                    },
                  ),
                  Gap(20),
                  TextInput(
                    label: Text("Scientific Name"),
                    onChanged: (value) =>
                        setState(() => inhabitant.scientificName = value),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return "Scientific name is required";
                      }

                      return null;
                    },
                  ),
                  Gap(20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ImageUploadWidget(
                      unlockAspectRatio: image != null,
                      onImagePicked: (image) {
                        setState(() => this.image = image);
                      },
                      image: image,
                    ),
                  ),
                  Gap(20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      loading: loading,
                      text: "Add Inhabitant",
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (inhabitant.commonName?.isEmpty ??
                            false || inhabitant.scientificName.isEmpty) {
                          showToast(context,
                              title: "Error",
                              description: "Please fill all the fields",
                              toastType: ToastType.info);
                          return;
                        }
                        setState(() => loading = true);
                        try {
                          await context
                              .read<InhabitantsCubit>()
                              .createInhabitant(inhabitant, image);
                          setState(() => loading = false);
                          await dialogShow(context, "Thank you!",
                              "Thank you for adding this inhabitant. Until our team has reviewed it, it will only be visible to you.");
                          navPop(context);
                          widget.onInhabitantAdded(inhabitant);
                        } catch (e) {
                          setState(() => loading = false);
                          showToast(context,
                              title: "Error",
                              description: e.toString(),
                              toastType: ToastType.error);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
