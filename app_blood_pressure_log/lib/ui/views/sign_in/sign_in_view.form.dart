// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String UserEmailValueKey = 'userEmail';
const String PasswordValueKey = 'password';
const String ValidationCodeValueKey = 'validationCode';
const String ReEnterPasswordValueKey = 'reEnterPassword';

final Map<String, TextEditingController> _SignInViewTextEditingControllers = {};

final Map<String, FocusNode> _SignInViewFocusNodes = {};

final Map<String, String? Function(String?)?> _SignInViewTextValidations = {
  UserEmailValueKey: null,
  PasswordValueKey: null,
  ValidationCodeValueKey: null,
  ReEnterPasswordValueKey: null,
};

mixin $SignInView {
  TextEditingController get userEmailController =>
      _getFormTextEditingController(UserEmailValueKey);
  TextEditingController get passwordController =>
      _getFormTextEditingController(PasswordValueKey);
  TextEditingController get validationCodeController =>
      _getFormTextEditingController(ValidationCodeValueKey);
  TextEditingController get reEnterPasswordController =>
      _getFormTextEditingController(ReEnterPasswordValueKey);

  FocusNode get userEmailFocusNode => _getFormFocusNode(UserEmailValueKey);
  FocusNode get passwordFocusNode => _getFormFocusNode(PasswordValueKey);
  FocusNode get validationCodeFocusNode =>
      _getFormFocusNode(ValidationCodeValueKey);
  FocusNode get reEnterPasswordFocusNode =>
      _getFormFocusNode(ReEnterPasswordValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_SignInViewTextEditingControllers.containsKey(key)) {
      return _SignInViewTextEditingControllers[key]!;
    }

    _SignInViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _SignInViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_SignInViewFocusNodes.containsKey(key)) {
      return _SignInViewFocusNodes[key]!;
    }
    _SignInViewFocusNodes[key] = FocusNode();
    return _SignInViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    userEmailController.addListener(() => _updateFormData(model));
    passwordController.addListener(() => _updateFormData(model));
    validationCodeController.addListener(() => _updateFormData(model));
    reEnterPasswordController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    userEmailController.addListener(() => _updateFormData(model));
    passwordController.addListener(() => _updateFormData(model));
    validationCodeController.addListener(() => _updateFormData(model));
    reEnterPasswordController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          UserEmailValueKey: userEmailController.text,
          PasswordValueKey: passwordController.text,
          ValidationCodeValueKey: validationCodeController.text,
          ReEnterPasswordValueKey: reEnterPasswordController.text,
        }),
    );

    if (_autoTextFieldValidation || forceValidate) {
      updateValidationData(model);
    }
  }

  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _SignInViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _SignInViewFocusNodes.values) {
      focusNode.dispose();
    }

    _SignInViewTextEditingControllers.clear();
    _SignInViewFocusNodes.clear();
  }
}

extension ValueProperties on FormStateHelper {
  bool get hasAnyValidationMessage => this
      .fieldsValidationMessages
      .values
      .any((validation) => validation != null);

  bool get isFormValid {
    if (!_autoTextFieldValidation) this.validateForm();

    return !hasAnyValidationMessage;
  }

  String? get userEmailValue => this.formValueMap[UserEmailValueKey] as String?;
  String? get passwordValue => this.formValueMap[PasswordValueKey] as String?;
  String? get validationCodeValue =>
      this.formValueMap[ValidationCodeValueKey] as String?;
  String? get reEnterPasswordValue =>
      this.formValueMap[ReEnterPasswordValueKey] as String?;

  set userEmailValue(String? value) {
    this.setData(
      this.formValueMap..addAll({UserEmailValueKey: value}),
    );

    if (_SignInViewTextEditingControllers.containsKey(UserEmailValueKey)) {
      _SignInViewTextEditingControllers[UserEmailValueKey]?.text = value ?? '';
    }
  }

  set passwordValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PasswordValueKey: value}),
    );

    if (_SignInViewTextEditingControllers.containsKey(PasswordValueKey)) {
      _SignInViewTextEditingControllers[PasswordValueKey]?.text = value ?? '';
    }
  }

  set validationCodeValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ValidationCodeValueKey: value}),
    );

    if (_SignInViewTextEditingControllers.containsKey(ValidationCodeValueKey)) {
      _SignInViewTextEditingControllers[ValidationCodeValueKey]?.text =
          value ?? '';
    }
  }

  set reEnterPasswordValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ReEnterPasswordValueKey: value}),
    );

    if (_SignInViewTextEditingControllers.containsKey(
        ReEnterPasswordValueKey)) {
      _SignInViewTextEditingControllers[ReEnterPasswordValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasUserEmail =>
      this.formValueMap.containsKey(UserEmailValueKey) &&
      (userEmailValue?.isNotEmpty ?? false);
  bool get hasPassword =>
      this.formValueMap.containsKey(PasswordValueKey) &&
      (passwordValue?.isNotEmpty ?? false);
  bool get hasValidationCode =>
      this.formValueMap.containsKey(ValidationCodeValueKey) &&
      (validationCodeValue?.isNotEmpty ?? false);
  bool get hasReEnterPassword =>
      this.formValueMap.containsKey(ReEnterPasswordValueKey) &&
      (reEnterPasswordValue?.isNotEmpty ?? false);

  bool get hasUserEmailValidationMessage =>
      this.fieldsValidationMessages[UserEmailValueKey]?.isNotEmpty ?? false;
  bool get hasPasswordValidationMessage =>
      this.fieldsValidationMessages[PasswordValueKey]?.isNotEmpty ?? false;
  bool get hasValidationCodeValidationMessage =>
      this.fieldsValidationMessages[ValidationCodeValueKey]?.isNotEmpty ??
      false;
  bool get hasReEnterPasswordValidationMessage =>
      this.fieldsValidationMessages[ReEnterPasswordValueKey]?.isNotEmpty ??
      false;

  String? get userEmailValidationMessage =>
      this.fieldsValidationMessages[UserEmailValueKey];
  String? get passwordValidationMessage =>
      this.fieldsValidationMessages[PasswordValueKey];
  String? get validationCodeValidationMessage =>
      this.fieldsValidationMessages[ValidationCodeValueKey];
  String? get reEnterPasswordValidationMessage =>
      this.fieldsValidationMessages[ReEnterPasswordValueKey];
}

extension Methods on FormStateHelper {
  setUserEmailValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[UserEmailValueKey] = validationMessage;
  setPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PasswordValueKey] = validationMessage;
  setValidationCodeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ValidationCodeValueKey] = validationMessage;
  setReEnterPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ReEnterPasswordValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    userEmailValue = '';
    passwordValue = '';
    validationCodeValue = '';
    reEnterPasswordValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      UserEmailValueKey: getValidationMessage(UserEmailValueKey),
      PasswordValueKey: getValidationMessage(PasswordValueKey),
      ValidationCodeValueKey: getValidationMessage(ValidationCodeValueKey),
      ReEnterPasswordValueKey: getValidationMessage(ReEnterPasswordValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _SignInViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _SignInViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      UserEmailValueKey: getValidationMessage(UserEmailValueKey),
      PasswordValueKey: getValidationMessage(PasswordValueKey),
      ValidationCodeValueKey: getValidationMessage(ValidationCodeValueKey),
      ReEnterPasswordValueKey: getValidationMessage(ReEnterPasswordValueKey),
    });
