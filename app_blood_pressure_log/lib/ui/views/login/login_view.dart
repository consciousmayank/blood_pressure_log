import 'package:app_blood_pressure_log/ui/views/login/login_view.form.dart';
import 'package:flutter/material.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'login_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'userEmail', initialValue: "test@gmail.com"),
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
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                              errorText: viewModel.userEmailValidationMessage,
                              labelText: 'Enter Email Address',
                              hintText: 'johndoe@yopmail.com',
                              hintStyle: const TextStyle(color: Colors.grey),
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            onEditingComplete: () =>
                                passwordFocusNode.requestFocus(),
                            onFieldSubmitted: (value) =>
                                passwordFocusNode.requestFocus(),
                          ),
                          verticalSpaceMedium,
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              errorText: viewModel.userEmailValidationMessage,
                              labelText: 'Enter Password',
                              hintStyle: const TextStyle(color: Colors.grey),
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            onEditingComplete: () =>
                                hideKeyboard(context: context),
                            onFieldSubmitted: (value) =>
                                hideKeyboard(context: context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceLarge,
                  ElevatedButton(
                    onPressed: () {
                      viewModel.login();
                    },
                    child: const Text('Login'),
                  ),
                  verticalSpaceMedium,
                  Text(
                    'Or',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  verticalSpaceMedium,
                  OutlinedButton(
                    onPressed: () {
                      viewModel.takeToSignIn();
                    },
                    child: const Text(
                      'Create account',
                    ),
                  ),
                ],
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
