import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/views/sign_in/sign_in_view.form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'sign_in_viewmodel.dart';

@FormView(fields: [
  FormTextField(
    name: 'userEmail',
  ),
  FormTextField(name: 'password'),
  FormTextField(name: 'validationCode'),
  FormTextField(name: 'reEnterPassword'),
])
class SignInView extends StackedView<SignInViewModel> with $SignInView {
  const SignInView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SignInViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stepper(
        type: StepperType.vertical,
        connectorThickness: 1,
        steps: [
          Step(
            subtitle: viewModel.currentIndex == 0
                ? const Text('Enter following details to create a new account.')
                : null,
            title: const Text('Details'),
            content: AbsorbPointer(
              absorbing: viewModel.busy(accountCreateBusyObject),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                      controller: userEmailController,
                      focusNode: userEmailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffix:
                            viewModel.busy(checkUserNameAvailabilityBusyObject)
                                ? const SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(),
                                  )
                                : viewModel.userNameDetails!=null ? viewModel.userNameAvailable
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ) : const SizedBox.shrink(),
                        errorText: viewModel.userEmailValidationMessage,
                        labelText: 'Enter Email',
                        hintText: 'JohnDoe@yopmail.com',
                        hintStyle: const TextStyle(color: Colors.grey),
                        alignLabelWithHint: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onEditingComplete: () {
                        viewModel.isUserNameAvailable();
                        passwordFocusNode.requestFocus();
                      },
                      onFieldSubmitted: (value) {
                        viewModel.isUserNameAvailable();
                        passwordFocusNode.requestFocus();
                      }),
                  TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: viewModel.obscurePassword,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            viewModel.obscurePassword =
                            !viewModel.obscurePassword;
                            viewModel.rebuildUi();
                          },
                          icon: Icon(viewModel.obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined, size: 20,),
                        ),
                      errorText: viewModel.passwordValidationMessage,
                      labelText: 'Enter password',
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onEditingComplete: () =>
                        reEnterPasswordFocusNode.requestFocus(),
                    onFieldSubmitted: (value) =>
                        reEnterPasswordFocusNode.requestFocus(),
                  ),
                  TextFormField(
                    controller: reEnterPasswordController,
                    focusNode: reEnterPasswordFocusNode,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: viewModel.obscureReEnterPassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          viewModel.obscureReEnterPassword =
                          !viewModel.obscureReEnterPassword;
                          viewModel.rebuildUi();
                        },
                        icon: Icon(viewModel.obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined, size: 20,),
                      ),
                      errorText: viewModel.reEnterPasswordValidationMessage,
                      labelText: 'Re-enter password',
                      hintText: 'Re-enter Password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onEditingComplete: () => hideKeyboard(context: context),
                    onFieldSubmitted: (value) => hideKeyboard(context: context),
                  ),
                  verticalSpaceLarge,
                ],
              ),
            ).animate().slideX(
                  duration: 500.milliseconds,
                  begin: 2,
                  end: 0,
                ),
            isActive: viewModel.currentIndex == 0,
            state: viewModel.currentIndex == 0
                ? StepState.indexed
                : StepState.complete,
          ),
          Step(
            subtitle: viewModel.currentIndex == 1
                ? Text(
                    'A account validation code has been sent to ${viewModel.userEmailValue}.')
                : null,
            title: Text(
              'Validate',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    decoration: viewModel.currentIndex < 1
                        ? TextDecoration.lineThrough
                        : null,
                  ),
            ),
            content: Column(
              children: [
                TextFormField(
                  controller: validationCodeController,
                  focusNode: validationCodeFocusNode,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  decoration: InputDecoration(
                    errorText: viewModel.validationCodeValidationMessage,
                    labelText: 'Enter Validation Code',
                    hintText: '12345678',
                    hintStyle: const TextStyle(color: Colors.grey),
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onEditingComplete: () => hideKeyboard(context: context),
                  onFieldSubmitted: (value) => hideKeyboard(context: context),
                ),
                verticalSpaceLarge,
              ],
            ).animate().slideX(
                  duration: 500.milliseconds,
                  begin: 2,
                  end: 0,
                ),
            isActive: viewModel.currentIndex == 1,
            state: viewModel.currentIndex < 2
                ? StepState.indexed
                : StepState.complete,
          ),
          Step(
            // label: const Text('Profile'),
            subtitle: viewModel.currentIndex == 2
                ? const Text('Your account has been created')
                : null,
            title: Text(
              'Done',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    decoration: viewModel.currentIndex < 2
                        ? TextDecoration.lineThrough
                        : null,
                  ),
            ),
            content: Column(
              children: [
                Text(
                    'Welcome to BPM. You can use ${viewModel.userEmailValue} as the userId, along with the password provided.'),
                verticalSpaceLarge
              ],
            ).animate()
              ..slideY(
                  delay: 200.milliseconds,
                  duration: 1.seconds,
                  begin: 100,
                  end: 0),

            isActive: viewModel.currentIndex == 2,
            state: viewModel.currentIndex < 2
                ? StepState.indexed
                : StepState.complete,
          )
        ],
        currentStep: viewModel.currentIndex,
        onStepContinue: () {
          if (viewModel.currentIndex != 2) {
            viewModel.setIndex(viewModel.currentIndex + 1);
          }
        },
        onStepCancel: () {
          if (viewModel.currentIndex != 0) {
            viewModel.setIndex(viewModel.currentIndex - 1);
          }
        },
        controlsBuilder: (context, details) {
          Widget? returningWidget;
          viewModel.stepperDetail = details;
          switch (details.currentStep) {
            case 0:
              returningWidget = ElevatedButton(
                onPressed: () {
                  viewModel.sendAccountValidationCode().then((value) {
                    if (value) {
                      details.onStepContinue?.call();
                    }
                  });
                },
                child: const Text(
                  'Continue',
                ),
              );

            case 1:
              returningWidget = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text(
                      'Back',
                    ),
                  ),
                  horizontalSpaceSmall,
                  ElevatedButton(
                    onPressed: () {
                      viewModel.validateCode().then((value) {
                        if (value) {
                          details.onStepContinue?.call();
                        }
                      });
                    },
                    child: const Text(
                      'Verify',
                    ),
                  )
                ],
              );

            case 2:
              returningWidget = ElevatedButton(
                onPressed: () {
                  viewModel.loginUser();
                },
                child: const Text(
                  'Continue',
                ),
              );
          }

          return AnimatedContainer(
            duration: const Duration(seconds: 2),
            child: viewModel.anyObjectsBusy
                ? const CircularProgressIndicator()
                : returningWidget?.animate().slideX(
                      delay: 100.milliseconds,
                      duration: 500.milliseconds,
                      begin: details.currentStep % 2 == 0 ? 2 : -2,
                      end: 0,
                    ),
          );
        },
      ),
    );
  }

  @override
  SignInViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignInViewModel();

  @override
  void onViewModelReady(SignInViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  void onDispose(SignInViewModel viewModel) {
    viewModel.clearForm();
    super.onDispose(viewModel);
  }
}
