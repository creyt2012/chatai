// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:chatai/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'services/apple_sign_in/apple_sign_in_available.dart';
import 'services/status_service_admin.dart';
import 'firebase_options.dart';
import 'helper/admob_helper.dart';
import 'helper/notification_helper.dart';
import 'routes/pages.dart';
import 'routes/routes.dart';
import 'utils/Flutter Theam/themes.dart';
import 'utils/language/local_string.dart';
import 'utils/strings.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  AdMobHelper.initialization();


  Stripe.publishableKey = ApiConfig.stripePublishableKey;


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    // Locking Device Orientation
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  NotificationHelper.initialization();
  NotificationHelper.requestPermission();
  NotificationHelper.getBackgroundNotification();


  StatusService.init();

  appleSignInAvailable.check();

  // main app
  runApp(const MyApp());

}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (_, child) => GetMaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: Themes().theme,
        navigatorKey: Get.key,
        initialRoute: Routes.splashScreen,
        getPages: Pages.list,
        translations: LocalString(),
        locale: const Locale('en', 'US'),
        builder: (context, widget) {
          ScreenUtil.init(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          ); // Locking Device Orientation
        },
      ),
    );
  }
}