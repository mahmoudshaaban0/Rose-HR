import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class AppVectorGraphic extends StatelessWidget {
  const AppVectorGraphic({
    required this.path,
    super.key,
    this.color,
    this.width,
    this.height,
    this.semanticLabel,
    this.boxFit = BoxFit.contain,
  });
  final String path;
  final ColorFilter? color;
  final double? width;
  final double? height;
  final String? semanticLabel;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(path),
      width: width,
      height: height,
      semanticsLabel: semanticLabel,
      fit: boxFit,
      colorFilter: color,
    );
  }
}
