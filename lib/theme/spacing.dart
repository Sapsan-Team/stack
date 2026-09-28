import 'package:flutter/material.dart';

abstract class Spacing {
  Spacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  static const double sm2 = 10;
  static const double md2 = 14;

  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets screenHV = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: xl,
  );
  static const EdgeInsets formH = EdgeInsets.symmetric(horizontal: xxl);
  static const EdgeInsets bottomSheet = EdgeInsets.fromLTRB(xxl, sm, xxl, xxxl);

  static const SizedBox hXs = SizedBox(height: xs);
  static const SizedBox hSm = SizedBox(height: sm);
  static const SizedBox hMd = SizedBox(height: md);
  static const SizedBox hLg = SizedBox(height: lg);
  static const SizedBox hXl = SizedBox(height: xl);
  static const SizedBox hXxl = SizedBox(height: xxl);
  static const SizedBox hXxxl = SizedBox(height: xxxl);
  static const SizedBox h28 = SizedBox(height: 28);
  static const SizedBox h14 = SizedBox(height: md2);

  static const SizedBox wXs = SizedBox(width: xs);
  static const SizedBox wSm = SizedBox(width: sm);
  static const SizedBox wMd = SizedBox(width: md);
  static const SizedBox wLg = SizedBox(width: lg);
  static const SizedBox wXl = SizedBox(width: xl);
  static const SizedBox w14 = SizedBox(width: md2);
}
