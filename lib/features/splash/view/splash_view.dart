import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToNextScreen(context);
  }

  // navigation decision
  Future<void> navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    // user onboarding box (get already opened box)
    var userOnBoardingBox = Hive.box<bool>("userOnBoardingBox");
    bool userOnBoardingStatus =
        userOnBoardingBox.get("userOnBoardingStatus", defaultValue: false)!;

    // user auth box (get already opened box)
    var userAuthBox = Hive.box<bool>("userAuthBox");
    bool userAuthStatus =
        userAuthBox.get("userAuthStatus", defaultValue: false)!;

    if (!context.mounted) return;

    if (userAuthStatus && userOnBoardingStatus) {
      GoRouter.of(context).pushReplacementNamed("home");
    } else if (userOnBoardingStatus) {
      GoRouter.of(context).pushReplacementNamed("authLogin");
    } else {
      GoRouter.of(context).pushReplacementNamed("onBoarding");
    }
  }

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
