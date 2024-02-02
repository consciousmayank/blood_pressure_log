import 'package:app_blood_pressure_log/ui/views/permissions/notification_permission/notification_permission_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NotificationPermissionView extends StatelessWidget {
  const NotificationPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationPermissionViewModel>.reactive(
      builder: (context, viewModel, child) => viewModel.isBusy
          ? const CircularProgressIndicator()
          : (viewModel.data as bool)
          ? ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(
              'Notification Permission',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: const Text(
                'To inform you about any upcoming Blood Pressure measurement. Or any urgent message.'),
          )
          : const SizedBox.shrink(),
      viewModelBuilder: () => NotificationPermissionViewModel(),
    );
  }
}
