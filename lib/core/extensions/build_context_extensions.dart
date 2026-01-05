import 'package:flutter/material.dart';

/// Context Extension for responsive design
extension ContextExtension on BuildContext {
  /// Theme data
  ThemeData get theme => Theme.of(this);

  /// Screen height
  double get height => MediaQuery.sizeOf(this).height;

  /// Screen width
  double get width => MediaQuery.sizeOf(this).width;

  /// View insets (keyboard height, etc.)
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // Responsive height sizes (calculated for 932px height - iPhone 14 Pro Max)
  /// 4px equivalent
  double get height4 => height * 0.004;

  /// 6px equivalent
  double get height6 => height * 0.007;

  /// 8px equivalent
  double get height8 => height * 0.009;

  /// 10px equivalent
  double get height10 => height * 0.011;

  /// 12px equivalent
  double get height12 => height * 0.013;

  /// 16px equivalent
  double get height16 => height * 0.017;

  /// 18px equivalent
  double get height18 => height * 0.020;

  /// 20px equivalent
  double get height20 => height * 0.021;

  /// 24px equivalent
  double get height24 => height * 0.026;

  /// 26px equivalent
  double get height26 => height * 0.028;

  /// 28px equivalent
  double get height28 => height * 0.030;

  /// 32px equivalent
  double get height32 => height * 0.034;

  /// 36px equivalent
  double get height36 => height * 0.039;

  /// 40px equivalent
  double get height40 => height * 0.043;

  /// 44px equivalent
  double get height44 => height * 0.047;

  /// 48px equivalent
  double get height48 => height * 0.052;

  /// 52px equivalent
  double get height52 => height * 0.056;

  /// 56px equivalent
  double get height56 => height * 0.060;

  /// 60px equivalent
  double get height60 => height * 0.064;

  /// 64px equivalent
  double get height64 => height * 0.069;

  /// 68px equivalent
  double get height68 => height * 0.073;

  /// 72px equivalent
  double get height72 => height * 0.077;

  /// 76px equivalent
  double get height76 => height * 0.082;

  /// 80px equivalent
  double get height80 => height * 0.086;

  /// 84px equivalent
  double get height84 => height * 0.090;

  /// 88px equivalent
  double get height88 => height * 0.094;

  /// 90px equivalent
  double get height90 => height * 0.097;

  /// 92px equivalent
  double get height92 => height * 0.099;

  /// 96px equivalent
  double get height96 => height * 0.103;

  /// 100px equivalent
  double get height100 => height * 0.107;

  /// 104px equivalent
  double get height104 => height * 0.112;

  /// 120px equivalent
  double get height120 => height * 0.129;

  /// 130px equivalent
  double get height130 => height * 0.139;

  /// 140px equivalent
  double get height140 => height * 0.150;

  /// 160px equivalent
  double get height160 => height * 0.172;

  /// 200px equivalent
  double get height200 => height * 0.215;

  /// 240px equivalent
  double get height240 => height * 0.258;

  /// 280px equivalent
  double get height280 => height * 0.300;

  /// 300px equivalent
  double get height300 => height * 0.322;

  // Responsive width sizes (calculated for 430px width - iPhone 14 Pro Max)
  /// 4px equivalent
  double get width4 => width * 0.009;

  /// 6px equivalent
  double get width6 => width * 0.014;

  /// 8px equivalent
  double get width8 => width * 0.019;

  /// 10px equivalent
  double get width10 => width * 0.023;

  /// 12px equivalent
  double get width12 => width * 0.028;

  /// 16px equivalent
  double get width16 => width * 0.037;

  /// 20px equivalent
  double get width20 => width * 0.047;

  /// 24px equivalent
  double get width24 => width * 0.056;

  /// 26px equivalent
  double get width26 => width * 0.060;

  /// 28px equivalent
  double get width28 => width * 0.065;

  /// 32px equivalent
  double get width32 => width * 0.074;

  /// 36px equivalent
  double get width36 => width * 0.084;

  /// 40px equivalent
  double get width40 => width * 0.093;

  /// 44px equivalent
  double get width44 => width * 0.102;

  /// 48px equivalent
  double get width48 => width * 0.112;

  /// 52px equivalent
  double get width52 => width * 0.121;

  /// 56px equivalent
  double get width56 => width * 0.130;

  /// 60px equivalent
  double get width60 => width * 0.140;

  /// 64px equivalent
  double get width64 => width * 0.149;

  /// 68px equivalent
  double get width68 => width * 0.158;

  /// 72px equivalent
  double get width72 => width * 0.167;

  /// 76px equivalent
  double get width76 => width * 0.177;

  /// 80px equivalent
  double get width80 => width * 0.186;

  /// 84px equivalent
  double get width84 => width * 0.195;

  /// 88px equivalent
  double get width88 => width * 0.205;

  /// 92px equivalent
  double get width92 => width * 0.214;

  /// 96px equivalent
  double get width96 => width * 0.223;

  /// 100px equivalent
  double get width100 => width * 0.233;

  /// 110px equivalent
  double get width110 => width * 0.256;

  /// 112px equivalent
  double get width112 => width * 0.260;

  /// 116px equivalent
  double get width116 => width * 0.270;

  /// 120px equivalent
  double get width120 => width * 0.279;

  /// 140px equivalent
  double get width140 => width * 0.326;

  /// 160px equivalent
  double get width160 => width * 0.372;

  /// 200px equivalent
  double get width200 => width * 0.465;

  /// 240px equivalent
  double get width240 => width * 0.558;

  /// 280px equivalent
  double get width280 => width * 0.651;

  /// 300px equivalent
  double get width300 => width * 0.698;
}
