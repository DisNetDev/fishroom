import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../core/constants.dart';
import '../../../core/usecases/upload_image.dart';

class ImageUploadWidget extends StatefulWidget {
  const ImageUploadWidget({super.key, required this.onImagePicked});

  final Function(File) onImagePicked;

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? image;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.transparent;

    return InkWell(
      onTap: () async {
        image = await pickImage(context);
        setState(() {});
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            color: color,
            border: const GradientBoxBorder(
              gradient: LinearGradient(
                colors: [kPrimaryColor, kSecondaryColor],
              ),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: image == null
              ? const Center(
                  child: Text("Upload Image"),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
