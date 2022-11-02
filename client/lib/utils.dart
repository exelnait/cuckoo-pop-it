import 'dart:math';

import 'package:flutter/material.dart';
import 'package:username_gen/username_gen.dart';

class Utils {
  static generateUserName() {
    return UsernameGen().generate();
  }

  static Color generateColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}
