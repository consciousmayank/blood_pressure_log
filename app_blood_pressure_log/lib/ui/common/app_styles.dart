import 'package:flutter/material.dart';

ButtonStyle get negativeOutlineButtonStyle => OutlinedButton.styleFrom(
      backgroundColor: Colors.grey.shade300,
      foregroundColor: Colors.red,
      elevation: 5,
      shadowColor: Colors.red,
      shape: RoundedRectangleBorder(
        // side: BorderSide.none,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      side: const BorderSide(
        color: Colors.red,
        width: 1,
      ),
    );


ButtonStyle positiveOutlineButtonStyle({
  Color? backgroundColor,
  Color? borderColor,
  required Color foreGroundColor,
  required Color shadowColor,
}) => OutlinedButton.styleFrom(
  backgroundColor: backgroundColor ?? Colors.grey.shade300,
  foregroundColor: foreGroundColor,
  elevation: 5,
  shadowColor: shadowColor,
  shape: RoundedRectangleBorder(
    // side: BorderSide.none,
    borderRadius: BorderRadius.circular(
      10,
    ),
  ),
  side: BorderSide(
    color: borderColor ?? shadowColor,
    width: 1,
  ),
);


ButtonStyle positiveTextButtonStyle({
  Color? backgroundColor,
  Color? borderColor,
  required Color foreGroundColor,
  required Color shadowColor,
}) => TextButton.styleFrom(
  backgroundColor: backgroundColor ?? Colors.grey.shade300,
  foregroundColor: foreGroundColor,
  elevation: 5,
  shadowColor: shadowColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      10,
    ),
  ),
  // side: BorderSide(
  //   color: borderColor ?? shadowColor,
  //   width: 1,
  // ),
);
