import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateEditingController extends TextEditingController {
  String dateTimeToString(DateTime dateTime) =>
      DateFormat('yyyy-MM-dd', 'en_US').format(dateTime).toString();

  DateTime get date => DateFormat('yyyy-MM-dd', 'en_US').parse(text);

  set date(DateTime dateTime) {
    text = dateTimeToString(dateTime);
  }
}
