import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class SnackBarHelper {
  // 🔁 Common background colors
  static const Color errorColor = ColorName.authErrorColor;
  static const Color successColor = ColorName.toastSuccessColor;
  static const Color warningColor = ColorName.warningSnackBarColor;

  /// ✅ Show custom snack bar
  static void showSnackBar({
    required BuildContext context,
    required IconData leadingIcon,
    required String message,
    Color backgroundColor = errorColor, // Default to error
    Color textColor = ColorName.white,
    int durationInSeconds = 3,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(leadingIcon, color: ColorName.white, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: () => scaffoldMessenger.hideCurrentSnackBar(),
              child: Icon(Icons.close, color: ColorName.white),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        duration: Duration(seconds: durationInSeconds),
      ),
    );
  }
}
