import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';
import 'package:smart_ambulance_system/firebase_options.dart';

final GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  // firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // hive initialization
  await Hive.initFlutter();

  // open a Hive box for storing authentication state
  await Hive.openBox<bool>('authBox');

  // email auth service
  locator.registerLazySingleton(() => EmailPasswordAuthService());

  // email auth provider
  locator.registerFactory(() => EmailPasswordProvider());
}
