import 'package:app_blood_pressure_log/ui/views/permissions/gallery_permission/gallery_permission_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GalleryPermissionView extends StatelessWidget {
  const GalleryPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GalleryPermissionViewModel>.reactive(
      builder: (context, viewModel, child) => viewModel.isBusy
          ? const CircularProgressIndicator()
          : (viewModel.data as bool)
              ? ListTile(
                leading: const Icon(Icons.photo),
                title: Text(
                  'Gallery Permission',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: const Text(
                    'To select an already captured image and upload it while adding a new record.'),
              )
              : const SizedBox.shrink(),
      viewModelBuilder: () => GalleryPermissionViewModel(),
    );
  }
}
