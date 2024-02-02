import 'package:app_blood_pressure_log/app/app.bottomsheets.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:app_blood_pressure_log/model_classes/account_create_response.dart';
import 'package:app_blood_pressure_log/model_classes/api_error.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/errors/errors_sheet.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/common/validation_checks.dart';
import 'package:app_blood_pressure_log/ui/views/sign_in/sign_in_view.form.dart';
import 'package:dio/dio.dart';
import 'package:flutter/src/material/stepper.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends FormViewModel with IndexTrackingStateHelper {
  final IAppNetworkService _networkService = locator<AppNetworkService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  bool obscurePassword = true;
  bool obscureReEnterPassword = true;
  final String errorTitle = "Error while Registering";
  ControlsDetails? stepperDetail;
  String? userNameDetails;

  get userNameAvailable =>
      userNameDetails != null && userNameDetails!.isNotEmpty ? true : false;

  takeToHomeView() {
    _navigationService.replaceWithHomeView();
  }

  Future isUserNameAvailable() async {
    if (userEmailValue != null) {
      userNameDetails = await runBusyFuture(
        _networkService.isUserNameAvailable(userName: userEmailValue!),
        busyObject: checkUserNameAvailabilityBusyObject,
      );
    }
  }

  Future<bool> sendAccountValidationCode() async {
    if (formValid()) {
      AccountCreateResponse accountCreateResponseCode = await runBusyFuture(
        _networkService.createAccount(
            email: userEmailValue!, password: passwordValue!),
        busyObject: accountCreateBusyObject,
      );

      if (accountCreateResponseCode.otp != null) {
        return true;
      } else {
        return false;
      }
    } else {
      rebuildUi();
      return false;
    }
  }

  Future<bool> validateCode() async {
    if (validationCodeValid()) {
      bool validateAccount = await runBusyFuture(
        _networkService.validateAccount(validationCode: validationCodeValue!),
        busyObject: accountCreateValidationBusyObject,
      );

      return validateAccount;
    } else {
      rebuildUi();
      return false;
    }
  }

  bool formValid() {
    bool isFormValid = true;
    if (userEmailValue == null || userEmailValue?.isEmpty == true) {
      setUserEmailValidationMessage('Required');
      isFormValid = false;
    }
    if (passwordValue == null || passwordValue?.isEmpty == true) {
      setPasswordValidationMessage('Required');
      isFormValid = false;
    }
    if ((passwordValue?.length ?? 0) < 8) {
      setPasswordValidationMessage('Password length should be more then 7');
      isFormValid = false;
    }
    if (reEnterPasswordValue != passwordValue) {
      setReEnterPasswordValidationMessage('Password not mactching');
      isFormValid = false;
    }

    if (!ValidationChecks().isValidEmail(email: userEmailValue)) {
      setUserEmailValidationMessage('Invalid Email. Please check.');
      return false;
    }
    return isFormValid;
  }

  bool validationCodeValid() {
    bool isValidationCodeValid = true;
    if (validationCodeValue == null || validationCodeValue?.isEmpty == true) {
      setValidationCodeValidationMessage('Required');
      isValidationCodeValid = false;
    }

    if (validationCodeValue?.length != 6) {
      setValidationCodeValidationMessage(
          'Validation code is invalid. \nPlease check inbox of "$userEmailValue" ');
      isValidationCodeValid = false;
    }

    return isValidationCodeValid;
  }

  void loginUser() async {
    var loginResponse = await runBusyFuture(
      _networkService.loginUser(
        userName: userEmailValue!,
        password: passwordValue!,
      ),
      busyObject: loginBusyObject,
    );

    if (loginResponse) {
      _navigationService.clearStackAndShow(Routes.homeView);
    } else {
      _navigationService.back();
    }
  }

  @override
  void onFutureError(error, Object? key) {
    if (error is DioException) {
      DioException dioError = error;
      if (key is String) {
        if (key == accountCreateBusyObject) {
          if (dioError.response?.statusCode == 409) {
            ApiError apiError = ApiError.fromMap(dioError.response!.data);
            _bottomSheetService
                .showCustomSheet(
              variant: BottomSheetType.errors,
              data: ErrorsSheetInArgs(
                description: apiError.detail,
                title: errorTitle,
              ),
            )
                .then((value) {
              clearForm();
            });
          }
        } else if (key == checkUserNameAvailabilityBusyObject) {
          if (dioError.response?.statusCode == 409) {
            ApiError apiError = ApiError.fromMap(dioError.response!.data);
            setUserEmailValidationMessage(apiError.detail);
            userNameDetails = null;
          }
        } else if (key == accountCreateValidationBusyObject) {
          if (dioError.response?.statusCode == 400) {
            ApiError apiError = ApiError.fromMap(dioError.response!.data);
            _bottomSheetService.showCustomSheet(
              variant: BottomSheetType.errors,
              data: ErrorsSheetInArgs(
                description: apiError.detail,
                title: errorTitle,
              ),
            );
          }
        }
      }
    }

    super.onFutureError(error, key);
  }
}
