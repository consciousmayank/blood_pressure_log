import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/views/login/login_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends FormViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final IAppNetworkService _networkService = locator<AppNetworkService>();
  late final loginResponse;
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
    return true;
  }

  void takeToSignIn() {
    _navigationService.navigateToSignInView();
  }
}
