import 'dart:io';
import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart'; // Import Material package for UI components

Future<File?> pickImage(BuildContext context) async {
  File? filePicked;
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: [
            const Text(
              "Pick an Image",
              style: kHeading1TextStyle,
            ),
            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        XFile? pickedImage = await _pick(ImageSource.gallery);
                        if (pickedImage != null && context.mounted) {
                          filePicked = File(pickedImage.path);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          border: GradientBoxBorder(gradient: kPrimaryGradient),
                        ),
                        child: const Icon(Icons.photo),
                      ),
                    ),
                    const Text("Pick from Gallery")
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        XFile? pickedImage = await _pick(ImageSource.camera);
                        if (pickedImage != null && context.mounted) {
                          filePicked = File(pickedImage.path);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          border: GradientBoxBorder(gradient: kPrimaryGradient),
                        ),
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                    const Text("Take a photo")
                  ],
                )
              ],
            ),
          ],
        ),
      );
    },
  );
  return filePicked;
}

Future<XFile?> _pick(ImageSource source) async {
  ImagePicker picker = ImagePicker();
  XFile? file = await picker.pickImage(source: source);
  return file;
}
