import 'dart:async';
import 'dart:ui';


import '../helper/local_storage.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../utils/constants.dart';
import 'main_controller.dart';


class SplashController extends GetxController {
  // final homeController = Get.put(HomeController());


  @override
  void onReady() {
    // homeController.getCredentials();
    var languageList = LocalStorage.getLanguage();
    var locale = Locale(languageList[0], languageList[1]);

    languageStateName = languageList[2];

    Get.updateLocale(locale);


    MainController.getCredentials();

    _goToScreen();

    super.onReady();
  }

  _goToScreen() async {
    Timer(const Duration(seconds: 3), () {
      LocalStorage.isLoggedIn()
          ? LocalStorage.showAdPermissioned()
              ? LocalStorage.getSubscriptionStatus()
                ? Get.offAndToNamed(Routes.purchasePlanScreen)
                : Get.offAndToNamed(Routes.homeScreen)
              : Get.offAndToNamed(Routes.homeScreen)
          : Get.offAndToNamed(Routes.loginScreen);
    });
  }
}
