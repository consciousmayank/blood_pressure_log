import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';

import 'app_image_container_model.dart';

class AppImageContainer extends StackedView<AppImageContainerModel> {
  final String imageUrl;
  final double? height, width;

  const AppImageContainer({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  @override
  Widget builder(
    BuildContext context,
    AppImageContainerModel viewModel,
    Widget? child,
  ) {
    return CachedNetworkImage(
        height: height ?? screenWidth(context),
        width: width ?? screenWidth(context),
        fit: BoxFit.fitWidth,
        imageUrl: imageUrl,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        httpHeaders: {
          "Authorization": viewModel.fetchToken(),
        });
  }

  @override
  AppImageContainerModel viewModelBuilder(
    BuildContext context,
  ) =>
      AppImageContainerModel();
}
