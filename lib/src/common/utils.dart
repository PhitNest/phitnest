import 'package:flutter/material.dart';

extension FormatQuantity on double {
  /// This will return a rounded string version of this [double] with [unit]
  /// appended as the units of measurement.
  ///
  /// Examples:    1.2.formatQuantity('mile') == '1.2 miles'
  ///              1.273532.formatQuantity('inch') == '1.3 inchs'
  ///              1.0.formatQuantity('meter') == '1 meter'
  ///              2.0.formatQuantity('cm') == '2 cms'
  String formatQuantity(String unit) =>
      '${this.floor().toDouble() == this ? this.floor() : this.toStringAsFixed(1)} $unit${this == 1 ? '' : 's'}';
}

/// When you tap a text field, it takes roughly 600 milliseconds for the keyboard to appear.
/// This function will delay the callback by 600 milliseconds.
Future<void> onTappedTextField(VoidCallback onFocusedCallback) =>
    Future.delayed(
      const Duration(milliseconds: 600),
      onFocusedCallback,
    );

/// This function will scroll to the given [offset] on the given [controller].
void scroll(ScrollController controller, double offset) {
  controller.animateTo(
    offset,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOut,
  );
}
