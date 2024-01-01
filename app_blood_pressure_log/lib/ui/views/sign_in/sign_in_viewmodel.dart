import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/views/sign_in/sign_in_view.form.dart';
import 'package:flutter/src/material/stepper.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends FormViewModel with IndexTrackingStateHelper {
  final IAppNetworkService _networkService = locator<AppNetworkService>();
  final NavigationService _navigationService = locator<NavigationService>();

  bool obscurePassword = true;
  bool obscureReEnterPassword = true;

  ControlsDetails? stepperDetail;

  takeToHomeView() {
    _navigationService.replaceWithHomeView();
  }

  Future<bool> sendAccountValidationCode() async {
    if (formValid()) {
      bool accountCreateResponse = await runBusyFuture(
        _networkService.createAccount(
            email: userEmailValue!, password: passwordValue!),
        busyObject: accountCreateBusyObject,
      );

      return accountCreateResponse;
    } else {
      rebuildUi();
      return false;
    }
  }

  Future<bool> validateCode() async {
    if (validationCodeValid()) {
      bool validateAccount = await runBusyFuture(
        _networkService.validateAccount(validationCode: validationCodeValue!),
        busyObject: accountCreateBusyObject,
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
          'Validation code is invalid. Please check inbox of "$userEmailValue" ');
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

    if (loginResponse != null) {
      _navigationService.clearStackAndShow(Routes.homeView);
    } else {
      _navigationService.back();
    }
  }
}
