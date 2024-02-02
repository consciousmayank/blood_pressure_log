import 'package:flutter/material.dart';

extension CardsExtension on Widget {
  Widget appCard({
    required Color shadowColor,
    Color? cardColor,
    double? elevation,
  }) {
    return Card(
      color: cardColor,
      shadowColor: shadowColor,
      elevation: elevation ?? 5,
      child: this,
    );
  }
}
