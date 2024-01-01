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
// @stacked-import

@StackedApp(routes: [
  MaterialRoute(page: HomeView),
  MaterialRoute(page: StartupView),
  MaterialRoute(page: LoginView),
  MaterialRoute(page: SignInView),
// @stacked-route
], dependencies: [
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: AppNetworkService),
  InitializableSingleton(classType: AppPreferencesService),
// @stacked-service
], bottomsheets: [
  StackedBottomsheet(classType: NoticeSheet),
  StackedBottomsheet(classType: ViewRecordSheet),
// @stacked-bottom-sheet
], dialogs: [
  StackedDialog(classType: InfoAlertDialog),
  StackedDialog(classType: AddEntryDialog),
// @stacked-dialog
], logger: StackedLogger())
class App {}
