import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MaterialContainer extends StatelessWidget {
  const MaterialContainer(
      {super.key,
      this.elevation,
      this.decoration,
      this.child,
      this.margin,
      this.padding,
      this.onTap,
      this.height,
      this.width,
      this.heroTag,
      this.constraints,
      this.duration = const Duration(milliseconds: 200)});

  final double? elevation;
  final BoxDecoration? decoration;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final Duration duration;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    Uuid uuid = const Uuid();
    return Hero(
      tag: heroTag ?? uuid.v4(),
      child: Padding(
        padding: margin ?? const EdgeInsets.all(0),
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            clipBehavior: Clip.none,
            duration: const Duration(milliseconds: 200),
            constraints: constraints,
            height: height,
            width: width,
            decoration: decoration,
            child: Material(
                color: decoration?.color ?? Colors.transparent,
                borderRadius: decoration?.borderRadius,
                elevation: elevation ?? 0,
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(0),
                  child: child,
                )),
          ),
        ),
      ),
    );
  }
}
