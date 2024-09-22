import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';

class ImageUpload extends StatelessWidget {
  const ImageUpload({super.key, required this.onTap, required this.image});

  final Function() onTap;

  final XFile? image;

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            color: isDarkTheme ? Colors.black26 : Colors.white,
            image: DecorationImage(
              image: AssetImage(image?.path ?? ""),
              fit: BoxFit.cover,
            ),
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
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
