import 'dart:io';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart'; // Import Material package for UI components

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
                        XFile? pickedImage =
                            await _pickAndCompress(ImageSource.gallery);
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
                        XFile? pickedImage =
                            await _pickAndCompress(ImageSource.camera);
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

Future<XFile?> _pickAndCompress(ImageSource source) async {
  ImagePicker picker = ImagePicker();
  XFile? xFile = await picker.pickImage(source: source);

  try {
    if (xFile != null) {
      File file = File(xFile.path);

      var dir = await getTemporaryDirectory();
      final String targetPath = "${dir.path}${const Uuid().v4()}.jpeg";

      XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path, targetPath,
          quality: 10, numberOfRetries: 5, format: CompressFormat.jpeg);
      return compressedImage;
    }
  } on Exception catch (_) {
    rethrow;
  }
  return null;
}
