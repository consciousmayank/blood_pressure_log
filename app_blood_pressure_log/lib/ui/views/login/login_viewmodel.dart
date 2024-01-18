import 'package:app_blood_pressure_log/app/app.bottomsheets.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.logger.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:app_blood_pressure_log/model_classes/api_error.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/errors/errors_sheet.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/common/validation_checks.dart';
import 'package:app_blood_pressure_log/ui/views/login/login_view.form.dart';
import 'package:dio/dio.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends FormViewModel {
  final bottomSheetService = locator<BottomSheetService>();
  final _logger = getLogger('LoginViewModel');
  final NavigationService _navigationService = locator<NavigationService>();
  final IAppNetworkService _networkService = locator<AppNetworkService>();
  late final loginResponse;
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  set obscureText(bool value) {
    _obscureText = value;
    notifyListeners();
  }

  void login() async {
    if (formHasNoErrors()) {
      loginResponse = await runBusyFuture(
        _networkService.loginUser(
          userName: userEmailValue!,
          password: passwordValue!,
        ),
        busyObject: loginBusyObject,
      );

      if (loginResponse) {
        _navigationService.replaceWithHomeView();
      }
    } else {
      rebuildUi();
    }
  }

  bool formHasNoErrors() {
    if (userEmailValue == null || userEmailValue?.isEmpty == true) {
      setUserEmailValidationMessage('Required');
      return false;
    }
    if (passwordValue == null || passwordValue?.isEmpty == true) {
      setPasswordValidationMessage('Required');
      return false;
    }
    if ((passwordValue?.length ?? 0) < 8) {
      setPasswordValidationMessage('Password length should be more then 7');
      return false;
    }
    if (!ValidationChecks().isValidEmail(email: userEmailValue)) {
      setUserEmailValidationMessage('Invalid Email. Please check.');
      return false;
    }
    return true;
  }

  void takeToSignIn() {
    _navigationService.navigateToSignInView();
  }

  @override
  void onFutureError(error, Object? key) {
    if (key is String) {
      if (key == loginBusyObject) {
        if (error is DioException) {
          DioException dioError = error;
          if (dioError.response?.statusCode == 401) {
            ApiError loginError = ApiError.fromMap(dioError.response!.data);
            bottomSheetService.showCustomSheet(
              variant: BottomSheetType.errors,
              data: ErrorsSheetInArgs(description: loginError.detail),
            ).then((value){
              clearForm();
            });
          }
        }
      }
    }

    _logger.wtf("key:${key.toString()}");
    super.onFutureError(error, key);
  }
}
