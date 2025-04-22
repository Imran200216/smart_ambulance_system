import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class CustomDrawerHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String profileFirstUserName;

  const CustomDrawerHeader({
    super.key,
    required this.fullName,
    required this.email,
    required this.profileFirstUserName,
  });

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: ColorName.primary),
      accountName: Text(
        fullName,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(email, style: TextStyle(fontSize: 14.sp)),
      currentAccountPicture: Container(
        height: 50.h,
        width: 50.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            profileFirstUserName.toUpperCase(),
            style: TextStyle(
              color: ColorName.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
