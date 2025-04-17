import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_ambulance_system/core/service/haptics/haptic_feedback_service.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class CustomIconFilledBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String btnTitle;
  final bool isLoading;
  final String iconPath;

  const CustomIconFilledBtn({
    super.key,
    required this.onTap,
    required this.btnTitle,
    this.isLoading = false,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          isLoading
              ? null
              : () {
                HapticFeedbackUtilityService.mediumImpact();

                onTap();
              }, // Disable tap when loading
      child: Container(
        height: 36.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color:
              isLoading
                  ? ColorName.primary.withOpacity(0.7)
                  : ColorName.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isLoading)
              SvgPicture.asset(
                iconPath,
                height: 18.w,
                width: 18.w,
                color: ColorName.white,
              ),
            if (!isLoading) SizedBox(width: 10.w),
            // Add spacing between icon and text
            isLoading
                ? SizedBox(
                  height: 20.w,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(ColorName.white),
                  ),
                )
                : Text(
                  btnTitle,
                  style: TextStyle(
                    color: ColorName.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
