import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateEditingController extends TextEditingController {
  static final DateFormat kFormat = DateFormat('yyyy-MM-dd', 'en_US');

  DateTime get date => kFormat.parse(text);

  set date(DateTime dateTime) {
    text = kFormat.format(dateTime).toString();
  }
}
