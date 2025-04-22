import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';
import 'package:smart_ambulance_system/features/home/home_exports.dart';
import 'package:smart_ambulance_system/features/on_boarding/on_boarding_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // service locator
  await setUpLocator();

  // Initialize AppInfoProvider
  final appInfoProvider = locator<AppInfoProvider>();
  await appInfoProvider.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // app info provider
        ChangeNotifierProvider(
          create: (context) => locator.get<AppInfoProvider>(),
        ),

        // on boarding provider
        ChangeNotifierProvider(
          create: (context) => locator.get<OnBoardingProvider>(),
        ),

        // email password provider
        ChangeNotifierProvider(
          create: (context) => locator.get<EmailPasswordProvider>(),
        ),

        // employee details provider
        ChangeNotifierProvider(
          create: (context) => locator.get<EmployeeDetailsProvider>(),
        ),

        // toggle search provider
        ChangeNotifierProvider(
          create: (context) => locator.get<SearchToggleProvider>(),
        ),

        // show route toggle provider
        ChangeNotifierProvider(
          create: (context) => locator.get<ShowRouteToggleProvider>(),
        ),

        // map search provider
        ChangeNotifierProvider(
          create: (context) => locator.get<MapSearchProvider>(),
        ),

        // email launch provider
        ChangeNotifierProvider(
          create: (context) => locator.get<EmailLauncherProvider>(),
        ),

        // terms privacy provider
        ChangeNotifierProvider(
          create: (context) => locator.get<TermsPrivacyLauncherProvider>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Smart Ambulance System',
            // themes
            theme: AppTheme.lightTheme,
            // routing
            routerConfig: router,
          );
        },
      ),
    );
  }
}
