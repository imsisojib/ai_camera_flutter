import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  final double size;
  final bool centerLoading;

  const Loading({
    super.key,
    this.size = 48,
    this.centerLoading = true,
  });

  ///DO NOT USE .h/.w for size, already in use

  @override
  Widget build(BuildContext context) {
    return centerLoading ? Center(
      child: Lottie.asset(
        'assets/animations/loading_lottie.json',
        repeat: true,
        height: size.h,
        width: size.h,
      ),
    ) : Lottie.asset(
      'assets/animations/loading_lottie.json',
      repeat: true,
      height: size.h,
      width: size.h,
    );
  }
}
