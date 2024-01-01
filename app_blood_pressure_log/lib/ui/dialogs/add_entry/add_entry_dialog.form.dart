// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String SystolicValueInputValueKey = 'systolicValueInput';
const String DiastolicValueInputValueKey = 'diastolicValueInput';

final Map<String, TextEditingController> _AddEntryDialogTextEditingControllers =
    {};

final Map<String, FocusNode> _AddEntryDialogFocusNodes = {};

final Map<String, String? Function(String?)?> _AddEntryDialogTextValidations = {
  SystolicValueInputValueKey: null,
  DiastolicValueInputValueKey: null,
};

mixin $AddEntryDialog {
  TextEditingController get systolicValueInputController =>
      _getFormTextEditingController(SystolicValueInputValueKey);
  TextEditingController get diastolicValueInputController =>
      _getFormTextEditingController(DiastolicValueInputValueKey);

  FocusNode get systolicValueInputFocusNode =>
      _getFormFocusNode(SystolicValueInputValueKey);
  FocusNode get diastolicValueInputFocusNode =>
      _getFormFocusNode(DiastolicValueInputValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_AddEntryDialogTextEditingControllers.containsKey(key)) {
      return _AddEntryDialogTextEditingControllers[key]!;
    }

    _AddEntryDialogTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddEntryDialogTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddEntryDialogFocusNodes.containsKey(key)) {
      return _AddEntryDialogFocusNodes[key]!;
    }
    _AddEntryDialogFocusNodes[key] = FocusNode();
    return _AddEntryDialogFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    systolicValueInputController.addListener(() => _updateFormData(model));
    diastolicValueInputController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    systolicValueInputController.addListener(() => _updateFormData(model));
    diastolicValueInputController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          SystolicValueInputValueKey: systolicValueInputController.text,
          DiastolicValueInputValueKey: diastolicValueInputController.text,
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

    for (var controller in _AddEntryDialogTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddEntryDialogFocusNodes.values) {
      focusNode.dispose();
    }

    _AddEntryDialogTextEditingControllers.clear();
    _AddEntryDialogFocusNodes.clear();
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

  String? get systolicValueInputValue =>
      this.formValueMap[SystolicValueInputValueKey] as String?;
  String? get diastolicValueInputValue =>
      this.formValueMap[DiastolicValueInputValueKey] as String?;

  set systolicValueInputValue(String? value) {
    this.setData(
      this.formValueMap..addAll({SystolicValueInputValueKey: value}),
    );

    if (_AddEntryDialogTextEditingControllers.containsKey(
        SystolicValueInputValueKey)) {
      _AddEntryDialogTextEditingControllers[SystolicValueInputValueKey]?.text =
          value ?? '';
    }
  }

  set diastolicValueInputValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DiastolicValueInputValueKey: value}),
    );

    if (_AddEntryDialogTextEditingControllers.containsKey(
        DiastolicValueInputValueKey)) {
      _AddEntryDialogTextEditingControllers[DiastolicValueInputValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasSystolicValueInput =>
      this.formValueMap.containsKey(SystolicValueInputValueKey) &&
      (systolicValueInputValue?.isNotEmpty ?? false);
  bool get hasDiastolicValueInput =>
      this.formValueMap.containsKey(DiastolicValueInputValueKey) &&
      (diastolicValueInputValue?.isNotEmpty ?? false);

  bool get hasSystolicValueInputValidationMessage =>
      this.fieldsValidationMessages[SystolicValueInputValueKey]?.isNotEmpty ??
      false;
  bool get hasDiastolicValueInputValidationMessage =>
      this.fieldsValidationMessages[DiastolicValueInputValueKey]?.isNotEmpty ??
      false;

  String? get systolicValueInputValidationMessage =>
      this.fieldsValidationMessages[SystolicValueInputValueKey];
  String? get diastolicValueInputValidationMessage =>
      this.fieldsValidationMessages[DiastolicValueInputValueKey];
}

extension Methods on FormStateHelper {
  setSystolicValueInputValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[SystolicValueInputValueKey] =
          validationMessage;
  setDiastolicValueInputValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DiastolicValueInputValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    systolicValueInputValue = '';
    diastolicValueInputValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      SystolicValueInputValueKey:
          getValidationMessage(SystolicValueInputValueKey),
      DiastolicValueInputValueKey:
          getValidationMessage(DiastolicValueInputValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _AddEntryDialogTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddEntryDialogTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      SystolicValueInputValueKey:
          getValidationMessage(SystolicValueInputValueKey),
      DiastolicValueInputValueKey:
          getValidationMessage(DiastolicValueInputValueKey),
    });
