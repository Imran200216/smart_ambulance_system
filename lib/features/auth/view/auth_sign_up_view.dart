import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:smart_ambulance_system/gen/assets.gen.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';
import 'package:smart_ambulance_system/commons/common_widgets_exports.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';

class AuthSignUpView extends StatefulWidget {
  const AuthSignUpView({super.key});

  @override
  State<AuthSignUpView> createState() => _AuthSignUpViewState();
}

class _AuthSignUpViewState extends State<AuthSignUpView> {
  // controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController empIdController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fullNameController.dispose();
    empIdController.dispose();
    phoneNoController.dispose();
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
                      validator:
                          (value) =>
                              AppValidator.validateFullName(context, value),
                      textEditingController: fullNameController,
                      keyboardType: TextInputType.name,
                      hasBorder: true,
                      hintText: "Full Name",
                      prefixIcon: Assets.icon.svg.profile,
                    ),

                    // emp id text field
                    CustomTextField(
                      readOnly: true,
                      validator:
                          (value) => AppValidator.validateEmpId(context, value),
                      textEditingController: empIdController,
                      keyboardType: TextInputType.number,
                      hasBorder: true,
                      hintText: "Employee ID",
                      isUidGenerate: true,
                      prefixIcon: Assets.icon.svg.profile,
                    ),

                    // phone number text field
                    CustomTextField(
                      validator:
                          (value) =>
                              AppValidator.validatePhoneNumber(context, value),
                      textEditingController: phoneNoController,
                      keyboardType: TextInputType.phone,
                      hasBorder: true,
                      hintText: "Phone Number",
                      prefixIcon: Assets.icon.svg.call,
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
                          "I accept all Terms of Service and Privacy Policy",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // create account btn
                    CustomIconFilledBtn(
                      isLoading: emailPasswordAuthProvider.isLoading,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          final isRegistered = await emailPasswordAuthProvider
                              .registerUser(
                                context: context,
                                fullName: fullNameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                phoneNumber: phoneNoController.text.trim(),
                                empId: empIdController.text.trim(),
                              );

                          if (isRegistered) {
                            // Hive auth box
                            final authBox = Hive.box<bool>('userAuthBox');

                            // Set auth state
                            await authBox.put('userAuthStatus', true);

                            // Navigate to home
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
      ),
    );
  }
}
