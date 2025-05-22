import 'dart:io';

import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../../core/usecases/pick_image.dart';

class ImageUploadWidget extends StatelessWidget {
  const ImageUploadWidget(
      {super.key,
      required this.onImagePicked,
      this.image,
      this.imageUrl,
      this.unlockAspectRatio = false});

  final Function(File) onImagePicked;
  final File? image;
  final bool unlockAspectRatio;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.transparent;

    return NeoBruteBorder(
      child: InkWell(
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
      ),
    );
  }

  Widget _buildImage(Color color) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Builder(builder: (context) {
          if (image == null && imageUrl == null) {
            return const Center(
              child: Text("Upload an Image"),
            );
          }

          if (image != null) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(image!, fit: BoxFit.cover),
            );
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl!, fit: BoxFit.cover),
              ),
              SimpleShadow(
                child: Icon(
                  Icons.edit,
                  size: 40,
                  color: Colors.white,
                ),
              )
            ],
          );
        }));
  }
}
