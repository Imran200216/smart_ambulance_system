import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:smart_ambulance_system/commons/common_widgets_exports.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/gen/assets.gen.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';

class AuthLoginView extends StatefulWidget {
  const AuthLoginView({super.key});

  @override
  State<AuthLoginView> createState() => _AuthLoginViewState();
}

class _AuthLoginViewState extends State<AuthLoginView> {
  // controllers
  final TextEditingController empIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    empIdController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  spacing: 10.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      validator:
                          (value) => AppValidator.validateEmpId(context, value),
                      textEditingController: empIdController,
                      keyboardType: TextInputType.text,
                      hasBorder: true,
                      hintText: "Employee ID",
                      prefixIcon: Assets.icon.svg.profile,
                    ),

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

                    // password text field
                    CustomTextField(
                      validator:
                          (value) =>
                              AppValidator.validatePassword(context, value),
                      textEditingController: passwordController,
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
                            GoRouter.of(
                              context,
                            ).pushNamed("authForgetPassword");
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

                    SizedBox(height: 20.h),

                    // sign in btn
                    CustomIconFilledBtn(
                      isLoading: emailPasswordAuthProvider.isLoading,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          final isSignedIn = await emailPasswordAuthProvider
                              .signInUser(
                                context: context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                          if (isSignedIn) {
                            // Hive auth box
                            final authBox = Hive.box<bool>('userAuthBox');

                            // Set auth state
                            await authBox.put('userAuthStatus', true);
                            // home
                            GoRouter.of(context).pushNamed("home");
                          }
                        } else {
                          // Show snackbar if form is invalid
                          SnackBarHelper.showSnackBar(
                            context: context,
                            leadingIcon: Icons.warning,
                            message: 'Please fill in all the required fields',
                            backgroundColor: SnackBarHelper.errorColor,
                          );
                        }
                      },
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
        ),
      ),
    );
  }
}
