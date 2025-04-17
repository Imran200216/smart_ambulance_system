import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),

              // Logo text
              Text(
                "Smart Ambulance",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
