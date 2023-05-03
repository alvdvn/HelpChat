
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension MyString on String? {
  bool isNullOrBlank() => this == null || this!.trim().isEmpty;
}

extension MyBuildContext on BuildContext {
  String getFormattedTime(DateTime date) {
    final now = DateTime.now();
    final days = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (days == 0) {
      return TimeOfDay.fromDateTime(date).format(this);
    }
    return DateFormat('MM-dd-yyyyHH:mm', Platform.localeName).format(date);
  }
}
