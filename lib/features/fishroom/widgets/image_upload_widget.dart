import 'dart:io';

import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:flutter/material.dart';

import '../../../core/usecases/pick_image.dart';

class ImageUploadWidget extends StatelessWidget {
  const ImageUploadWidget(
      {super.key,
      required this.onImagePicked,
      required this.image,
      this.unlockAspectRatio = false});

  final Function(File) onImagePicked;
  final File? image;
  final bool unlockAspectRatio;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.transparent;

    return InkWell(
      onTap: () async {
        File? pickedFile = await pickImage(context);

        if (pickedFile != null) {
          onImagePicked(pickedFile);
        }
      },
      child: unlockAspectRatio
          ? _buildImage(color)
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildImage(color),
            ),
    );
  }

  Widget _buildImage(Color color) {
    return NeoBruteBorder(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          color: color,
        ),
        child: image == null
            ? const Center(
                child: Text("Optional: Upload an Image"),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
