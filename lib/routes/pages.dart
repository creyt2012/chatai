
import 'package:get/get.dart';

import '../binding/splash_binding.dart';
import '../views/chat_screen.dart';
import '../views/home_screen.dart';
import '../views/image_screen.dart';
import '../views/login_screen.dart';
import '../views/purchase_plan_screen.dart';
import '../views/splash_screen/splash_screen.dart';
import '../views/update_profile_screen.dart';
import 'routes.dart';

class Pages {
  static var list = [
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => LogInScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.purchasePlanScreen,
      page: () => PurchasePlanScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.homeScreen,
      page: () => HomeScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.chatScreen,
      page: () => ChatScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.searchScreen,
      page: () => ImageScreen(),
      // binding: SplashBinding(),
    ),


    GetPage(
      name: Routes.updateProfileScreen,
      page: () => UpdateProfileScreen(),
      // binding: SplashBinding(),
    ),

  ];
}
