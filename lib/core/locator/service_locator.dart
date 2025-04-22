import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';
import 'package:smart_ambulance_system/features/home/home_exports.dart';
import 'package:smart_ambulance_system/features/on_boarding/on_boarding_exports.dart';
import 'package:smart_ambulance_system/firebase_options.dart';

// locator instance
final GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  // firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // hive initialization
  await Hive.initFlutter();

  // open a Hive box for storing authentication state
  await Hive.openBox<bool>('userAuthBox');

  // open a Hive box for storing onboarding state
  await Hive.openBox<bool>('userOnBoardingBox');

  // app info provider
  locator.registerLazySingleton(() => AppInfoProvider());

  // email auth service
  locator.registerLazySingleton(() => EmailPasswordAuthService());

  // on boarding provider
  locator.registerLazySingleton(() => OnBoardingProvider());

  // email auth provider
  locator.registerLazySingleton(() => EmailPasswordProvider());

  // employee details provider
  locator.registerLazySingleton(() => EmployeeDetailsProvider());

  // search toggle provider
  locator.registerLazySingleton(() => SearchToggleProvider());

  // show route toggle provider
  locator.registerLazySingleton(() => ShowRouteToggleProvider());

  // map search provider
  locator.registerLazySingleton(() => MapSearchProvider());

  // email launcher provider
  locator.registerLazySingleton(() => EmailLauncherProvider());

  // terms privacy launcher provider
  locator.registerLazySingleton(() => TermsPrivacyLauncherProvider());
}
