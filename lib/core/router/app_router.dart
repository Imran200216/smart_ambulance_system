import 'package:go_router/go_router.dart';
import 'package:smart_ambulance_system/features/home/home_exports.dart';
import 'package:smart_ambulance_system/features/on_boarding/on_boarding_exports.dart';
import 'package:smart_ambulance_system/features/splash/splash_exports.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';
import 'package:smart_ambulance_system/features/settings/settings_exports.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // splash view
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => SplashView(),
    ),

    // on boarding view
    GoRoute(
      path: '/onBoarding',
      name: 'onBoarding',
      builder: (context, state) => OnBoardingView(),
    ),

    // auth login view
    GoRoute(
      path: '/authLogin',
      name: 'authLogin',
      builder: (context, state) => AuthLoginView(),
    ),

    // auth sign view
    GoRoute(
      path: '/authSignUp',
      name: 'authSignUp',
      builder: (context, state) => AuthSignUpView(),
    ),

    // auth forget password view
    GoRoute(
      path: '/authForgetPassword',
      name: 'authForgetPassword',
      builder: (context, state) => AuthForgetPasswordView(),
    ),

    // home view
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomeView(),
    ),

    // settings view
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => SettingsView(),
    ),
  ],
);
