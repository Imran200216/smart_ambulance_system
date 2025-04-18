import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_ambulance_system/gen/assets.gen.dart';

class CustomOvalContainer extends StatelessWidget {
  final String imageUrl;
  final double containerHeight;
  final double containerWidth;
  final double containerBorderRadius;

  const CustomOvalContainer({
    super.key,
    required this.imageUrl,
    required this.containerHeight,
    required this.containerWidth,
    required this.containerBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        child: Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(containerBorderRadius),
          ),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Image.asset(
                  Assets.img.jpg.imgPlaceholder.path,
                  fit: BoxFit.cover,
                ),
            errorWidget:
                (context, url, error) => Image.asset(
                  Assets.img.jpg.imgPlaceholder.path,
                  fit: BoxFit.cover,
                ),
          ),
        ),
      ),
    );
  }
}
