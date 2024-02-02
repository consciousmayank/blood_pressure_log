import 'package:app_blood_pressure_log/ui/common/app_styles.dart';
import 'package:app_blood_pressure_log/ui/views/permissions/gallery_permission/gallery_permission_view.dart';
import 'package:app_blood_pressure_log/ui/views/permissions/notification_permission/notification_permission_view.dart';
import 'package:flutter/material.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:app_blood_pressure_log/ui/common/custom_widgets.dart';

import 'permissions_viewmodel.dart';

class PermissionsView extends StackedView<PermissionsViewModel> {
  const PermissionsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    PermissionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          children: [
            const Text(
                'For this application to work as intended, following permissions are required.'),
            verticalSpaceMedium,
            ListView(
              shrinkWrap: true,
              children: [
                const NotificationPermissionView().appCard(shadowColor: Theme.of(context).primaryColorDark),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    'Camera Permission',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: const Text(
                      'To capture a new image from camera and upload it while adding a new record.'),
                ).appCard(shadowColor: Theme.of(context).primaryColorDark),
                const GalleryPermissionView().appCard(shadowColor: Theme.of(context).primaryColorDark)
              ],
            ),
            verticalSpaceMedium,
            const Text(
                'These permissions are not mandatory, but will allow you to enhance the application experience by adding images to Blood Pressure record you input.'),
            const Spacer(),
            OutlinedButton.icon(
              style: positiveOutlineButtonStyle(
                  foreGroundColor: Theme.of(context).primaryColor,
                  shadowColor: Theme.of(context).primaryColorDark),
              onPressed: () {
                viewModel.allowPermissions();
              },
              icon: const Icon(Icons.check),
              label: const Text(
                "Allow Permissions",
              ),
            ),
            verticalSpaceLarge,
            OutlinedButton.icon(
              style: negativeOutlineButtonStyle,
              onPressed: () {
                viewModel.denyPermissions();
              },
              icon: const Icon(Icons.close),
              label: const Text(
                "Deny Permissions",
              ),
            ),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }

  @override
  PermissionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PermissionsViewModel();
}
