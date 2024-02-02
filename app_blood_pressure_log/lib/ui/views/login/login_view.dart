import 'package:app_blood_pressure_log/ui/common/semantics_extensions.dart';
import 'package:app_blood_pressure_log/ui/views/login/login_view.form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'login_viewmodel.dart';

@FormView(fields: [
  FormTextField(
    name: 'userEmail', /* initialValue: "test1@gmail.com"*/
  ),
  FormTextField(name: 'password', initialValue: "test@121"),
])
class LoginView extends StackedView<LoginViewModel> with $LoginView {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: viewModel.anyObjectsBusy
          ? const LoadingWidget()
          : SingleChildScrollView(
              child: SizedBox(
                height: screenHeight(context),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: userEmailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorText:
                                      viewModel.userEmailValidationMessage,
                                  labelText: 'Enter Email Address',
                                  hintText: 'johndoe@yopmail.com',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  alignLabelWithHint: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                onEditingComplete: () =>
                                    passwordFocusNode.requestFocus(),
                                onFieldSubmitted: (value) =>
                                    passwordFocusNode.requestFocus(),
                              )
                                  .semantic(semanticsLabel: "userName")
                                  .animate()
                                  .slideX(
                                    delay: 100.milliseconds,
                                    duration: 500.milliseconds,
                                    begin: -10,
                                    end: 0,
                                  ),
                              verticalSpaceMedium,
                              TextFormField(
                                controller: passwordController,
                                focusNode: passwordFocusNode,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: viewModel.obscureText,
                                decoration: InputDecoration(
                                    errorText:
                                        viewModel.passwordValidationMessage,
                                    labelText: 'Enter Password',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    alignLabelWithHint: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        viewModel.obscureText =
                                            !viewModel.obscureText;
                                      },
                                      icon: Icon(viewModel.obscureText
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined),
                                    )),
                                onEditingComplete: () =>
                                    hideKeyboard(context: context),
                                onFieldSubmitted: (value) =>
                                    hideKeyboard(context: context),
                              )
                                  .semantic(semanticsLabel: "password")
                                  .animate()
                                  .slideX(
                                    delay: 100.milliseconds,
                                    duration: 500.milliseconds,
                                    begin: 10,
                                    end: 0,
                                  ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 50.milliseconds, duration: 2.seconds),
                      verticalSpaceLarge,
                      ElevatedButton(
                        onPressed: () {
                          viewModel.login();
                        },
                        child: const Text('Login'),
                      )
                          .semantic(semanticsLabel: "loginButton")
                          .animate()
                          .slideX(duration: 2.seconds, begin: 100, end: 0),
                      verticalSpaceMedium,
                      Text(
                        'Or',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                          .animate()
                          .blurXY(duration: 5.seconds, begin: 200, end: 0),
                      verticalSpaceMedium,
                      OutlinedButton(
                        onPressed: () {
                          viewModel.takeToSignIn();
                        },
                        child: const Text(
                          'Create account',
                        ),
                      )
                          .semantic(semanticsLabel: "createAccountButton")
                          .animate()
                          .slideX(duration: 2.seconds, begin: -100, end: 0),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();

  @override
  void onViewModelReady(LoginViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  void onDispose(LoginViewModel viewModel) {
    viewModel.clearForm();
    super.onDispose(viewModel);
  }
}
