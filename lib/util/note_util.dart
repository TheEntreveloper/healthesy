import 'package:flutter/material.dart';

mixin NoteUtil {
  DateTime fieldAsDateTime(int value) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  String fieldAsDateOnly(BuildContext context, int value) {
    return MaterialLocalizations.of(context).formatCompactDate(fieldAsDateTime(value));
  }
}
