import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_ambulance_system/commons/common_widgets_exports.dart';
import 'package:smart_ambulance_system/gen/assets.gen.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class AuthLoginView extends StatelessWidget {
  const AuthLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              spacing: 10.h,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // svg img
                SvgPicture.asset(
                  Assets.img.svg.login,
                  height: 200.h,
                  width: 200.w,
                  fit: BoxFit.contain,
                ),

                // glad to have you black
                Text(
                  "Glad to have you back",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10.h),

                // emp id text field
                CustomTextField(
                  keyboardType: TextInputType.number,
                  hasBorder: true,
                  hintText: "Employee ID",
                  prefixIcon: Assets.icon.svg.profile,
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
                      "Remember me",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    // Forget password text btn
                    TextButton(
                      onPressed: () {
                        // auth forget password screen
                        GoRouter.of(context).pushNamed("authForgetPassword");
                      },
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorName.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                CustomIconFilledBtn(
                  onTap: () {},
                  btnTitle: "Sign In",
                  iconPath: Assets.icon.svg.login,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Remember me
                    Text(
                      "New here?",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    // Forget password text btn
                    TextButton(
                      onPressed: () {
                        // auth sign up
                        GoRouter.of(context).pushNamed("authSignUp");
                      },
                      child: Text(
                        "Create Account",
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
    );
  }
}
