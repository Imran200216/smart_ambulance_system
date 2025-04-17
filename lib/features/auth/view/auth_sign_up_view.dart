import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_ambulance_system/gen/assets.gen.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';
import 'package:smart_ambulance_system/commons/common_widgets_exports.dart';

class AuthSignUpView extends StatelessWidget {
  const AuthSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10.h,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // svg img
                  Center(
                    child: SvgPicture.asset(
                      Assets.img.svg.register,
                      height: 200.h,
                      width: 200.w,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // glad to have you black
                  Text(
                    "Please fill in your details",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Full name text field
                  CustomTextField(
                    keyboardType: TextInputType.name,
                    hasBorder: true,
                    hintText: "Full Name",
                    prefixIcon: Assets.icon.svg.profile,
                  ),

                  // emp id text field
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    hasBorder: true,
                    hintText: "Employee ID",
                    prefixIcon: Assets.icon.svg.profile,
                  ),

                  // phone number text field
                  CustomTextField(
                    keyboardType: TextInputType.phone,
                    hasBorder: true,
                    hintText: "Phone Number",
                    prefixIcon: Assets.icon.svg.call,
                  ),

                  // email text field
                  CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    hasBorder: true,
                    hintText: "Email Address",
                    prefixIcon: Assets.icon.svg.email,
                  ),

                  // password text field
                  CustomTextField(
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    hasBorder: true,
                    hintText: "Password",
                    prefixIcon: Assets.icon.svg.password,
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember me
                      Text(
                        "I accept all Terms of Service and Privacy Policy",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  CustomIconFilledBtn(
                    onTap: () {},
                    btnTitle: "Create Account",
                    iconPath: Assets.icon.svg.login,
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Remember me
                      Text(
                        "Have an account?",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      // Forget password text btn
                      TextButton(
                        onPressed: () {
                          // auth sign up
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
