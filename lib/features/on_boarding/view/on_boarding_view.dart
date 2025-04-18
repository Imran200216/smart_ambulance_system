import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';
import 'package:smart_ambulance_system/features/on_boarding/on_boarding_exports.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  // page controller
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      final pageIndex = pageController.page?.round() ?? 0;
      context.read<OnBoardingProvider>().setPage(pageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnBoardingProvider>();
    final currentPage = provider.currentPage;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorName.white,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              /// PageView
              Expanded(
                flex: 4,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    provider.setPage(index);
                  },
                  children: [
                    CustomOnBoarding(
                      onBoardingTitle: 'Welcome to Smart Ambulance System',
                      onBoardingSubTitle:
                          'Experience faster emergency response and real-time ambulance tracking for better healthcare support.',
                      imgUrlFirst: AppConstants.onBoardingPage1Img1,
                      imgUrlSecond: AppConstants.onBoardingPage1Img2,
                      imgUrlThird: AppConstants.onBoardingPage1Img3,
                      imgUrlFourth: AppConstants.onBoardingPage1Img4,
                    ),
                    CustomOnBoarding(
                      onBoardingTitle: 'Real-Time Tracking',
                      onBoardingSubTitle:
                          'Track ambulance location live and receive updates until it reaches your location.',
                      imgUrlFirst: AppConstants.onBoardingPage2Img1,
                      imgUrlSecond: AppConstants.onBoardingPage2Img2,
                      imgUrlThird: AppConstants.onBoardingPage2Img3,
                      imgUrlFourth: AppConstants.onBoardingPage2Img4,
                    ),
                    CustomOnBoarding(
                      onBoardingTitle: 'Seamless Emergency Requests',
                      onBoardingSubTitle:
                          'Request an ambulance in one tap and get the nearest unit dispatched instantly.',
                      imgUrlFirst: AppConstants.onBoardingPage3Img1,
                      imgUrlSecond: AppConstants.onBoardingPage3Img2,
                      imgUrlThird: AppConstants.onBoardingPage3Img3,
                      imgUrlFourth: AppConstants.onBoardingPage3Img4,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// SmoothPageIndicator + Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: ColorName.primary,
                      dotColor: ColorName.grey,
                      dotHeight: 5.h,
                      dotWidth: 10.w,
                    ),
                  ),

                  /// Next / Get Started Button
                  CustomOnBoardingBtn(
                    btnTitle: currentPage < 2 ? "Next" : "Get Started",
                    onTap: () async {
                      if (currentPage < 2) {
                        pageController.animateToPage(
                          currentPage + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        provider.setPage(currentPage + 1);
                      } else {
                        // 🔁 Use Hive.box instead of Hive.openBox
                        var box = Hive.box<bool>('userOnBoardingBox');
                        await box.put('userOnBoardingStatus', true);

                        if (!context.mounted) return;

                        GoRouter.of(context).pushReplacementNamed("authLogin");
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
