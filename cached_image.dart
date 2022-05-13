import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/ui/widgets/loading_widget.dart';
import 'package:food_app/data/api/api_provider.dart';

class CachedImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String imageUrl;
  final List<Widget>? stackedWidgets;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? customUrl;

  const CachedImage({
    Key? key,
    this.height,
    this.width,
    required this.imageUrl,
    this.stackedWidgets,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.customUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CachedNetworkImage(
          height: height,
          width: width,
          imageUrl:
              customUrl ?? ApiServiceProvider.baseUrl + '/storage/' + imageUrl,
          progressIndicatorBuilder: (context, url, progress) {
            return const LoadingWidget();
          },
          errorWidget: (context, url, error) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.circular(5),
                image: DecorationImage(
                  image: Image.asset('assets/images/logo_icon.png').image,
                  fit: fit,
                ),
              ),
            );
          },
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.circular(5),
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            );
          },
        ),
        ...?stackedWidgets,
      ],
    );
  }
}
