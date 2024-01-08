import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';

import 'app_image_container_model.dart';

class AppImageContainer extends StackedView<AppImageContainerModel> {
  final String imageUrl;

  const AppImageContainer({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget builder(
    BuildContext context,
    AppImageContainerModel viewModel,
    Widget? child,
  ) {
    return CachedNetworkImage(
        height: screenWidth(context) * 0.50,
        width: screenWidth(context) / 2,
        fit: BoxFit.fitWidth,
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
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
