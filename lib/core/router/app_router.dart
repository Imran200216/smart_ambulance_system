import 'package:go_router/go_router.dart';
import 'package:smart_ambulance_system/features/auth/view/auth_forget_password_view.dart';
import 'package:smart_ambulance_system/features/splash/splash_exports.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';

final GoRouter router = GoRouter(
  initialLocation: '/authLogin',
  routes: [
    // splash screen
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => SplashView(),
    ),

    // auth login screen
    GoRoute(
      path: '/authLogin',
      name: 'authLogin',
      builder: (context, state) => AuthLoginView(),
    ),

    // auth sign screen
    GoRoute(
      path: '/authSignUp',
      name: 'authSignUp',
      builder: (context, state) => AuthSignUpView(),
    ),

    // auth forget password screen
    GoRoute(
      path: '/authForgetPassword',
      name: 'authForgetPassword',
      builder: (context, state) => AuthForgetPasswordView(),
    ),
  ],
);
