import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/local_storage.dart';
import '../model/user_model/user_model.dart';
import '../routes/routes.dart';
import '../utils/strings.dart';
import '../widgets/api/logger.dart';
import '../widgets/api/toast_message.dart';

final log = logger(UpdateProfileController);

class UpdateProfileController extends GetxController {
  late UserModel userModel;

  final userUid = LocalStorage.getId();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late DocumentSnapshot userDoc;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isBtnLoading = false.obs;
  bool get isBtnLoading => _isBtnLoading.value;

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  getUserData() async {
    _isLoading.value = true;
    try {
      userDoc = await fireStore.collection('chataiUsers').doc(userUid).get();

      userModel = UserModel(
        name: userDoc.get('name') ?? "",
        uniqueId: userUid!,
        email: userDoc.get('email') ?? "",
        phoneNumber: userDoc.get('phoneNumber') ?? "",
        isActive: userDoc.get('isActive') ?? "",
        imageUrl: userDoc.get('image_url') ?? "",
        isPremium: userDoc.get('isPremium') ?? "",
      );

      nameController.text = userModel.name;
      numberController.text = userModel.phoneNumber;
      emailController.text = userModel.email;

      isEmailHave.value = userDoc.get('email') == "" ? false : true;

      debugPrint(userModel.toString());

      return userModel;
    } catch (e) {
      log.e("🐞🐞🐞 Printing Error from getUserData => $e  🐞🐞🐞");
      return null;
    } finally {
      _isLoading.value = false;
      update();
    }
  }


  final firebaseStorage = FirebaseStorage.instance;
  //-> Store File To Firebase
  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  updateUserData() async {
    try {

      _isBtnLoading.value = true;
      update();

      await fireStore.collection('chataiUsers').doc(userUid).update({
        "email": emailController.text,
        // "image_url": imageUrl,
        "name": nameController.text,
        "phoneNumber": numberController.text,
      });
      ToastMessage.success(Strings.updateProfile);
      Get.offAllNamed(Routes.homeScreen);
      return true;
    } catch (e) {
      log.e(
          "🐞🐞🐞 Printing Error from FirebaseService => getUserData => $e  🐞🐞🐞");
      return false;
    }finally{
      _isBtnLoading.value = false;
      update();
    }
  }


  RxBool imageSelected = false.obs;
  late File file;
  RxString filePathString = ''.obs;

  updateUserDataWithImage() async {
    try {
      _isBtnLoading.value = true;
      update();

      debugPrint("=======Image Upload Start=========");
      debugPrint("=======${file.toString()}=========");

      String filePath = await storeFileToFirebase(
          'profileImage/$userUid', file
      );

      debugPrint("=======$filePath=========");
      debugPrint("=======Image Upload End=========");


      await fireStore.collection('chataiUsers').doc(userUid).update({
        "email": emailController.text,
        "image_url": filePath,
        "name": nameController.text,
        "phoneNumber": numberController.text,
      });
      ToastMessage.success(Strings.updateProfile);
      Get.offAllNamed(Routes.homeScreen);
      return true;
    } catch (e) {
      log.e(
          "🐞🐞🐞 Printing Error from FirebaseService => getUserData => $e  🐞🐞🐞");
      return false;
    }finally{
      _isBtnLoading.value = false;
      update();
    }
  }

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  RxBool isEmailHave = true.obs;
}
