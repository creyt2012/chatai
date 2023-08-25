
import '../helper/notification_helper.dart';
import '../model/support_model/support_ticket.dart';
import '../services/apple_sign_in/auth_service.dart';
import '../widgets/api/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/local_storage.dart';
import '../model/user_model/user_model.dart';
import '../routes/routes.dart';
import '../widgets/api/logger.dart';

final log = logger(LoginController);

class LoginController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final FirebaseAuth _auth = FirebaseAuth.instance; // firebase instance/object

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // getting user auth status
  Stream<User?> get authChanges => _auth.authStateChanges();

  // getter for our user to access the user data from outside using this authChange getter
  User get user => _auth.currentUser!;

  // sign in with google account function
  // this function will return a boolean value
   signInWithGoogle(BuildContext context) async {
    bool result = false;
    try {
      _isLoading.value = true;
      update();
      // getting google user
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // taking google auth with the authentication
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth == null) {
        _isLoading.value = false;
        update();
      }
      // taking the credential of the user
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, // accessToken from google auth
        idToken: googleAuth?.idToken, // idToken from google auth
      );

      // user credential to use the firebase credential and sign in with the google account
      // also after this line of code the data will be reflected in the fireStore database
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Get the user form the firebase
      User? user = userCredential.user;

      _userFunctionDataStore(user, userCredential);
    } on FirebaseAuthException catch (e) {
      log.e(
          "🐞🐞🐞 Printing Error FirebaseAuthException => ${e.message!}  🐞🐞🐞");
      ToastMessage.error(e.message!);
      _isLoading.value = false;
      update();
      result = false;
    } on PlatformException catch (e) {
      _isLoading.value = false;
      update();
      log.e("🐞🐞🐞 Printing Error PlatformException => ${e.message!}  🐞🐞🐞");
    }
    _isLoading.value = false;
    update();
    return result;
  }

  void goToHomePage() {
    Get.toNamed(Routes.homeScreen);
  }


  setData(UserModel userData) async{
    await _fireStore
        .collection('chataiUsers')
        .doc(user.uid)
        .set(userData.toJson());

    _isLoading.value = false;
    update();

    if(LocalStorage.getAdMobStatus()){
      Get.offAllNamed(Routes.purchasePlanScreen);
    }else{
      Get.offAllNamed(Routes.homeScreen);
    }
  }

  void checkData(DocumentSnapshot<Object?> userDoc) {
    if (userDoc.get('isPremium')) {
      LocalStorage.saveTextCount(count: userDoc.get('textCount'));
      LocalStorage.showAdYes(isShowAdYes: !userDoc.get('isPremium'));
      Get.offAllNamed(Routes.homeScreen);
    } else {
      LocalStorage.saveTextCount(count: userDoc.get('textCount'));
      if(LocalStorage.getAdMobStatus()){
        Get.offAllNamed(Routes.purchasePlanScreen);
      }else{
        Get.offAllNamed(Routes.homeScreen);
      }
    }
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void sendSupportTicket({
    required String email,
    required String name,
    required String note,
}) async{

    _isLoading.value = true;

    SupportModel supportData = SupportModel(
        email: email,
        name: name,
        note: note,
    );

    try{
      await _fireStore
          .collection('supportData')
          .doc(email)
          .collection('issues')
          .doc()
          .set(supportData.toJson());

      ToastMessage.success('Send Your Issue Successfully');
      _isLoading.value = false;
      update();

    } on FirebaseAuthException catch (e) {
      log.e(
          "🐞🐞🐞 Printing Error FirebaseAuthException => ${e.message!}  🐞🐞🐞");
      ToastMessage.error(e.message!);
      _isLoading.value = false;
      update();
    } on PlatformException catch (e) {
      _isLoading.value = false;
      update();
      log.e("🐞🐞🐞 Printing Error PlatformException => ${e.message!}  🐞🐞🐞");
    } catch(e) {
      _isLoading.value = false;
      update();
      log.e("🐞🐞🐞 Printing Error PlatformException => ${e.toString()}  🐞🐞🐞");
    }
  }



  @override
  void onInit() {
    NotificationHelper.initInfo();
    super.onInit();
  }

  checkPremiumOrNot(UserModel userData) async{
    /// check free or premium

    final DocumentSnapshot userDoc = await _fireStore
        .collection('chataiUsers')
        .doc(user.uid)
        .get();

    if(userDoc.exists){
      checkData(userDoc);
    }else{
      setData(userData);
    }
    _isLoading.value = false;
    update();
  }


  Future<void> signInWithApple(BuildContext context) async {
    try {
      final authService = AuthService();

      final userCredential = await authService.signInWithApple();
      final user = userCredential.user!;

      debugPrint('uid: ${user.uid}');

      _userFunctionDataStore(user, userCredential);

    } catch (e) {
      ToastMessage.error(e.toString());
      debugPrint("----------${e.toString()}---------");
    }
  }

  _userFunctionDataStore(User? user, UserCredential userCredential) {
    debugPrint("----------Before Condition---------");
    debugPrint("----------${user?.uid}---------");

    if (user != null) {
      debugPrint("----------After Start Condition---------");

      // storing some data for future use
      ToastMessage.success("Login Success");
      LocalStorage.isLoginSuccess(isLoggedIn: true);
      LocalStorage.saveEmail(email: user.email ?? '');
      LocalStorage.saveName(name: user.displayName ?? "");
      LocalStorage.saveId(id: user.uid);

      debugPrint("----------Before Loc Save al Storage---------");


      // debugPrint(user.toString());

      debugPrint("_________________________________");


      UserModel userData = UserModel(
        name: user.displayName ?? "",
        uniqueId: user.uid,
        phoneNumber: user.phoneNumber ?? "",
        isActive: true,
        imageUrl: user.photoURL ?? "",
        isPremium: false,
        textCount: 0,
        imageCount: 0,
        email: user.email ?? '',
      );

      if (userCredential.additionalUserInfo!.isNewUser) {
        setData(userData);

      }
      else {
        checkPremiumOrNot(userData);
      }

    }
    else {
      _isLoading.value = false;
      update();
    }
  }

}
