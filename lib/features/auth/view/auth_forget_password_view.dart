import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_ambulance_system/gen/assets.gen.dart';
import 'package:smart_ambulance_system/commons/common_widgets_exports.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class AuthForgetPasswordView extends StatelessWidget {
  const AuthForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            spacing: 10.h,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // svg img
              SvgPicture.asset(
                Assets.img.svg.forgetPassword,
                height: 140.h,
                width: 140.w,
                fit: BoxFit.contain,
              ),

              // please fill in your details text
              Text(
                "Please fill in your details",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              // email text field
              CustomTextField(
                keyboardType: TextInputType.emailAddress,
                hasBorder: true,
                hintText: "Email Address",
                prefixIcon: Assets.icon.svg.email,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Remember me
                  Text(
                    "Remember your password?",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  // login text btn
                  TextButton(
                    onPressed: () {
                      // auth login
                      GoRouter.of(context).pushNamed("authLogin");
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorName.primary,
                      ),
                    ),
                  ),
                ],
              ),

              // send link btn
              CustomIconFilledBtn(
                onTap: () {},
                btnTitle: "Send link",
                iconPath: Assets.icon.svg.login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
