import 'package:app_blood_pressure_log/services/push_notifications_service.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:app_blood_pressure_log/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:app_blood_pressure_log/ui/views/home/home_view.dart';
import 'package:app_blood_pressure_log/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:app_blood_pressure_log/ui/dialogs/add_entry/add_entry_dialog.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/services/app_preferences_service.dart';
import 'package:app_blood_pressure_log/ui/views/login/login_view.dart';
import 'package:app_blood_pressure_log/ui/views/sign_in/sign_in_view.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/view_record/view_record_sheet.dart';

import 'package:app_blood_pressure_log/ui/bottom_sheets/errors/errors_sheet.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/add_record/add_record_sheet.dart';
import 'package:app_blood_pressure_log/ui/views/app_intro/app_intro_view.dart';
import 'package:app_blood_pressure_log/ui/views/permissions/permissions_view.dart';
import 'package:app_blood_pressure_log/services/app_permissions_service.dart';
// @stacked-import

@StackedApp(routes: [
  MaterialRoute(page: HomeView),
  MaterialRoute(page: StartupView),
  MaterialRoute(page: LoginView),
  MaterialRoute(page: SignInView),
  MaterialRoute(page: AppIntroView),
  MaterialRoute(page: PermissionsView),
// @stacked-route
], dependencies: [
  InitializableSingleton(classType: AppPreferencesService),
  InitializableSingleton(classType: PushNotificationsService),
  InitializableSingleton(classType: AppPermissionsService),
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: AppNetworkService),
  LazySingleton(classType: SnackbarService),
// @stacked-service
], bottomsheets: [
  StackedBottomsheet(classType: NoticeSheet),
  StackedBottomsheet(classType: ViewRecordSheet),
  StackedBottomsheet(classType: ErrorsSheet),
  StackedBottomsheet(classType: AddRecordSheet),
// @stacked-bottom-sheet
], dialogs: [
  StackedDialog(classType: InfoAlertDialog),
  StackedDialog(classType: AddEntryDialog),
// @stacked-dialog
], logger: StackedLogger())
class App {}
