import 'package:flutter/material.dart';

extension Space on num {
  Widget get verticalSpace => SizedBox(height: toDouble());
  Widget get horizontalSpace => SizedBox(width: toDouble());
}
