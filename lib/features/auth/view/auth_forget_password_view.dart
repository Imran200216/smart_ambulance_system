import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/gen/assets.gen.dart';
import 'package:smart_ambulance_system/commons/common_widgets_exports.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';

class AuthForgetPasswordView extends StatefulWidget {
  const AuthForgetPasswordView({super.key});

  @override
  State<AuthForgetPasswordView> createState() => _AuthForgetPasswordViewState();
}

class _AuthForgetPasswordViewState extends State<AuthForgetPasswordView> {
  // controller
  final TextEditingController emailController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // email password auth provider
    final emailPasswordAuthProvider = Provider.of<EmailPasswordProvider>(
      context,
    );

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Container(
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
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10.h),

                // email text field
                CustomTextField(
                  validator:
                      (value) => AppValidator.validateEmail(context, value),
                  textEditingController: emailController,
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
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      final isEmailSent = await emailPasswordAuthProvider
                          .resetPassword(
                            context: context,
                            email: emailController.text.trim(),
                          );

                      if (isEmailSent) {
                        // login view
                        GoRouter.of(context).pushNamed("authLogin");
                      }
                    } else {
                      // Show snackbar if form is invalid
                      SnackBarHelper.showSnackBar(
                        context: context,
                        leadingIcon: Icons.warning,
                        message: 'Please fill in the required fields',
                        backgroundColor: SnackBarHelper.errorColor,
                      );
                    }
                  },
                  btnTitle: "Send link",
                  iconPath: Assets.icon.svg.login,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
