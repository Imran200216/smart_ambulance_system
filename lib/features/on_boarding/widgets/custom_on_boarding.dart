import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_ambulance_system/features/on_boarding/on_boarding_exports.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class CustomOnBoarding extends StatelessWidget {
  final String onBoardingTitle;
  final String onBoardingSubTitle;
  final String imgUrlFirst;
  final String imgUrlSecond;
  final String imgUrlThird;
  final String imgUrlFourth;

  const CustomOnBoarding({
    super.key,
    required this.onBoardingTitle,
    required this.onBoardingSubTitle,
    required this.imgUrlFirst,
    required this.imgUrlSecond,
    required this.imgUrlThird,
    required this.imgUrlFourth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // images
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.w,
          children: [
            Column(
              spacing: 10.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomOvalContainer(
                  imageUrl: imgUrlFirst,
                  containerHeight: 100.h,
                  containerWidth: 80.w,
                  containerBorderRadius: 100.r,
                ),

                CustomOvalContainer(
                  imageUrl: imgUrlSecond,
                  containerHeight: 160.h,
                  containerWidth: 130.w,
                  containerBorderRadius: 80.r,
                ),
              ],
            ),

            Column(
              spacing: 10.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomOvalContainer(
                  imageUrl: imgUrlThird,
                  containerHeight: 160.h,
                  containerWidth: 130.w,
                  containerBorderRadius: 80.r,
                ),

                CustomOvalContainer(
                  imageUrl: imgUrlFourth,
                  containerHeight: 100.h,
                  containerWidth: 80.w,
                  containerBorderRadius: 100.r,
                ),
              ],
            ),
          ],
        ),

        Spacer(),

        /// title about on boarding
        Text(
          textAlign: TextAlign.start,
          onBoardingTitle,
          style: TextStyle(color: ColorName.black, fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 12.h),

        // Description about on boarding
        Text(
          textAlign: TextAlign.start,
          onBoardingSubTitle,
          style: TextStyle(color: ColorName.grey),
        ),
      ],
    );
  }
}
