// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/usecases/cache_image.dart';
import 'package:fishroom/core/usecases/get_filename_from_url.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:io'; // Import the dart:io library

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/widgets/material_container.dart';
import '../cubit/tanks_cubit.dart';
import '../views/tank_details.dart';

class TankTileCompact extends StatefulWidget {
  const TankTileCompact({super.key, required this.tank});
  final Tank tank;

  @override
  State<TankTileCompact> createState() => _TankTileCompactState();
}

class _TankTileCompactState extends State<TankTileCompact> {
  bool loadingImage = false;
  Future<void> updateImagePath() async {
    fishLog("Image for tank ${widget.tank.name} not found. Getting image...");
    if (widget.tank.imageUrl != null) {
      setState(() => loadingImage = true);
      widget.tank.imageLocalPath = await cacheImageFromUrl(
          widget.tank.imageUrl!, getFileNameFromUrl(widget.tank.imageUrl!));

      if (context.mounted) {
        await context.read<TanksCubit>().updateTank(widget.tank, null);
        setState(() => loadingImage = false);
      }
    } else {
      fishLog("Image for tank ${widget.tank.name} is empty.");
    }
  }

  @override
  void initState() {
    if (!File(widget.tank.imageLocalPath ?? "").existsSync()) {
      updateImagePath();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = 16;

    String tankTypeNonNullable = widget.tank.type ?? "Tank Type";
    if (tankTypeNonNullable == "") {
      tankTypeNonNullable = "Tank Type";
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TankDetails(tank: widget.tank)));
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (widget.tank.imageUrl != null)
            MaterialContainer(
              width: double.infinity,
              height: 75,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: !isDarkMode(context)
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.black,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Skeletonizer(
                  enabled: loadingImage,
                  child: Skeleton.replace(
                    child: widget.tank.imageLocalPath != null &&
                            File(widget.tank.imageLocalPath!)
                                .existsSync() // Check if the local image path is valid
                        ? Image(
                            image: FileImage(File(widget.tank.imageLocalPath!)),
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.tank.imageUrl ?? "",
                            errorWidget: (context, url, error) {
                              return const Center(child: SizedBox());
                            },
                            placeholder: (context, url) =>
                                const Center(child: Loader()),
                          ),
                  ),
                ),
              ),
            ),
          Skeleton.replace(
            child: Container(
              height: 75,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
              decoration: BoxDecoration(
                border: widget.tank.imageUrl != null
                    ? null
                    : const GradientBoxBorder(gradient: kPrimaryGradient),
                gradient: widget.tank.imageUrl != null
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.transparent, Colors.black],
                      )
                    : kPrimaryGradient,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.tank.name ?? "Tank Name",
                      textAlign: TextAlign.end,
                      textScaler: TextScaler.noScaling,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      "$tankTypeNonNullable ${widget.tank.size != null && widget.tank.measurementUnit != null ? "-" : ""} ${widget.tank.size ?? ""} ${widget.tank.measurementUnit ?? ""}",
                      textAlign: TextAlign.end,
                      textScaler: TextScaler.noScaling,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
