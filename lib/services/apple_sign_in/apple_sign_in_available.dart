import 'package:get/get.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';


final appleSignInAvailable = AppleSignInAvailable();

class AppleSignInAvailable {
  RxBool isAvailable = false.obs;

  Future<bool> check() async {
    isAvailable.value = await TheAppleSignIn.isAvailable();
    return isAvailable.value;
  }
}
