import 'package:flutter/material.dart';

class Medicine {
  final String title;
  final String time;
  final bool taken_today;

  Medicine(
      {@required this.title,
      @required this.time,
      @required this.taken_today});
}
