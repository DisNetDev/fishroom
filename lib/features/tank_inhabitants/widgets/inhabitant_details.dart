import 'dart:io';

import 'package:fishroom/core/usecases/dialog_show.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/fishroom/widgets/image_upload_widget.dart';
import 'package:fishroom/features/tank_inhabitants/cubit/inhabitants_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/constants.dart';
import '../../../core/usecases/capitalize_each_word.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/usecases/nav_push.dart';
import '../../../core/widgets/counter_wheel.dart';
import '../models/inhabitant.dart';

class InhabitantDetails extends StatefulWidget {
  const InhabitantDetails(
      {super.key, required this.inhabitant, required this.onAdd});

  final Inhabitant inhabitant;
  final void Function(Inhabitant) onAdd;

  @override
  State<InhabitantDetails> createState() => _InhabitantDetailsState();
}

class _InhabitantDetailsState extends State<InhabitantDetails> {
  late int numberOfInhabitants;

  @override
  void initState() {
    numberOfInhabitants = widget.inhabitant.count ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: NeoBruteBorder(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      capitalizeEachWord(widget.inhabitant.commonName ??
                          widget.inhabitant.scientificName),
                      style: kHeadingTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Gap(10),
                    if (widget.inhabitant.commonName != null &&
                        widget.inhabitant.commonName!.isNotEmpty)
                      Text(
                        capitalizeEachWord(widget.inhabitant.scientificName),
                        style: kHeading1TextStyle.copyWith(
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    Gap(20),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.inhabitant.imageUrl ?? "",
                          fit: BoxFit.fitWidth,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Loader();
                          },
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Symbols.image_not_supported_sharp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Gap(40),
                    Text(
                        "How many ${widget.inhabitant.commonName ?? widget.inhabitant.scientificName}s do you have?"),
                    Gap(10),
                    Material(
                        color: Colors.transparent,
                        child: CounterWheel(
                            initialValue: widget.inhabitant.count?.toDouble(),
                            valueSelected: (value) {
                              setState(
                                  () => numberOfInhabitants = value.toInt());
                            })),
                    Gap(10),
                    Text("Set to 0 to remove", style: kDateTimeTextStyle),
                    Gap(40),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => _SuggestEditDialog(
                            inhabitant: widget.inhabitant,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: SizedBox()),
                          Text("Suggest an Edit"),
                          Gap(10),
                          Icon(
                            Symbols.edit_rounded,
                          )
                        ],
                      ),
                    ),
                    Gap(20),
                    CustomButton(
                        text: widget.inhabitant.count == 0 ? "Add" : "Update",
                        onPressed: () {
                          navPop(context);
                          widget.onAdd(widget.inhabitant.copyWith(
                            count: numberOfInhabitants,
                          ));
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestEditDialog extends StatefulWidget {
  const _SuggestEditDialog({required this.inhabitant});

  final Inhabitant inhabitant;

  @override
  State<_SuggestEditDialog> createState() => _SuggestEditDialogState();
}

class _SuggestEditDialogState extends State<_SuggestEditDialog> {
  late Inhabitant newInhabitant;
  File? image;
  bool loading = false;

  @override
  void initState() {
    newInhabitant = widget.inhabitant.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Suggest an Edit",
                style: kHeadingTextStyle,
              ),
              Gap(10),
              TextInput(
                label: Text("Common Name"),
                initialValue: widget.inhabitant.commonName,
                onChanged: (value) {
                  setState(() => newInhabitant.commonName = value);
                },
              ),
              Gap(10),
              TextInput(
                label: Text("Scientific Name"),
                initialValue: widget.inhabitant.scientificName,
                onChanged: (value) {
                  setState(() => newInhabitant.scientificName = value);
                },
              ),
              Gap(20),
              ImageUploadWidget(
                onImagePicked: (file) => setState(() => image = file),
                image: image,
                imageUrl: widget.inhabitant.imageUrl,
                unlockAspectRatio:
                    image != null || widget.inhabitant.imageUrl != null,
              ),
              Gap(20),
              CustomButton(
                loading: loading,
                text: "Suggest Edit",
                onPressed: () async {
                  try {
                    setState(() => loading = true);
                    await context
                        .read<InhabitantsCubit>()
                        .suggestEdit(newInhabitant);
                    navPop(context);
                    dialogShow(context, "Thank You!",
                        "Your edit has been suggested, and our team will review it!",
                        onlyShowTrue: true);
                  } catch (e) {
                    setState(() => loading = false);
                    showToast(context,
                        title: "Error",
                        toastType: ToastType.error,
                        description: e.toString());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
