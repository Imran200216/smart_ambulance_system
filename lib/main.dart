import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // service locator
  await setUpLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // email password provider
        ChangeNotifierProvider(
          create: (context) => locator.get<EmailPasswordProvider>(),
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
