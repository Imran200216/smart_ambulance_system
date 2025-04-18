import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class CustomOnBoardingBtn extends StatelessWidget {
  final String btnTitle;
  final VoidCallback onTap;

  const CustomOnBoardingBtn({
    super.key,
    required this.btnTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        /// haptic feedback
        HapticFeedbackUtilityService.mediumImpact();

        onTap();
      },
      child: Container(
        height: 30.h,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: ColorName.transparent,
          border: Border.all(color: ColorName.primary, width: 1),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          child: Row(
            spacing: 6.w,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// next text
              Text(
                textAlign: TextAlign.center,
                btnTitle,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: ColorName.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Icon(Icons.arrow_forward, color: ColorName.black, size: 13.h),
            ],
          ),
        ),
      ),
    );
  }
}
