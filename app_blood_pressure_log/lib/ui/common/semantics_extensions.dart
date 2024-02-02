import 'package:flutter/material.dart';

extension SemanticsExtension on Widget {
  Widget semantic({
    required String semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel,
      child: this,
    );
  }
}
