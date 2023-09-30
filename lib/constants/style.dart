import 'package:final_project/constants/sizes.dart';
import 'package:flutter/material.dart';

extension CustomTextStyle on BuildContext {
  TextStyle get displayLarge => const TextStyle(
        fontSize: Sizes.size40,
        fontWeight: FontWeight.bold,
      );
  TextStyle get displayMedium => const TextStyle(
        fontSize: Sizes.size32,
        fontWeight: FontWeight.bold,
      );
  TextStyle get displaySmall => const TextStyle(
        fontSize: Sizes.size24,
        fontWeight: FontWeight.bold,
      );

  TextStyle get bodyLarge => const TextStyle(
        fontSize: Sizes.size32,
      );
  TextStyle get bodyMedium => const TextStyle(
        fontSize: Sizes.size24,
      );
  TextStyle get bodySmall => const TextStyle(
        fontSize: Sizes.size14,
      );
}
