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

final Map<String, TextEditingController> _AddRecordSheetTextEditingControllers =
    {};

final Map<String, FocusNode> _AddRecordSheetFocusNodes = {};

final Map<String, String? Function(String?)?> _AddRecordSheetTextValidations = {
  SystolicValueInputValueKey: null,
  DiastolicValueInputValueKey: null,
};

mixin $AddRecordSheet {
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
    if (_AddRecordSheetTextEditingControllers.containsKey(key)) {
      return _AddRecordSheetTextEditingControllers[key]!;
    }

    _AddRecordSheetTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddRecordSheetTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddRecordSheetFocusNodes.containsKey(key)) {
      return _AddRecordSheetFocusNodes[key]!;
    }
    _AddRecordSheetFocusNodes[key] = FocusNode();
    return _AddRecordSheetFocusNodes[key]!;
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

    for (var controller in _AddRecordSheetTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddRecordSheetFocusNodes.values) {
      focusNode.dispose();
    }

    _AddRecordSheetTextEditingControllers.clear();
    _AddRecordSheetFocusNodes.clear();
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

    if (_AddRecordSheetTextEditingControllers.containsKey(
        SystolicValueInputValueKey)) {
      _AddRecordSheetTextEditingControllers[SystolicValueInputValueKey]?.text =
          value ?? '';
    }
  }

  set diastolicValueInputValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DiastolicValueInputValueKey: value}),
    );

    if (_AddRecordSheetTextEditingControllers.containsKey(
        DiastolicValueInputValueKey)) {
      _AddRecordSheetTextEditingControllers[DiastolicValueInputValueKey]?.text =
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
  final validatorForKey = _AddRecordSheetTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddRecordSheetTextEditingControllers[key]!.text,
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
