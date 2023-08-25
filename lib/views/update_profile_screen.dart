import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/update_profile_controller.dart';
import '../utils/assets.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../widgets/api/custom_loading_api.dart';
import '../widgets/api/toast_message.dart';
import '../widgets/appbar/appbar_widget.dart';
import '../widgets/inputs_widgets/input_field.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key? key}) : super(key: key);

  final controller = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        appTitle: Strings.updateProfile.tr,
        onPressed: () {},
        moreVisible: false,
        onBackClick: () {
          Get.back();
        },
      ),
      body: _inputFields(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if(controller.imageSelected.value){
              controller.updateUserDataWithImage();
            }else{
              controller.updateUserData();
            }

          },
          child: Text(Strings.updateProfile.tr),
        ),
      ),
    );
  }

  _inputFields(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? const CustomLoadingAPI()
          : ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.widthSize,
                  vertical: Dimensions.heightSize),
              physics: const BouncingScrollPhysics(),
              children: [
                _imageWidget(context),

                InputField(
                  controller: controller.nameController,
                  hintText: 'Name',
                ),

                Visibility(
                  visible: controller.isEmailHave.value,
                  child: InputField(
                        readOnly: true,
                        controller: controller.emailController,
                        hintText: 'Email',
                      ),
                ),
                
                InputField(
                  controller: controller.numberController,
                  hintText: 'Number',
                ),
              ],
            ),
    );
  }

  _imageWidget(BuildContext context) {
    return InkWell(
      onTap: (){
        debugPrint('Select');
        pickImageFromGallery(context);
      },
      child: Container(
        alignment: Alignment.center,
        height: Dimensions.buttonHeight * 2,
        width: Dimensions.buttonHeight * 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 20)
        ),
        child: CircleAvatar(
          radius: 80,
          backgroundImage: controller.imageSelected.value
              ? FileImage(
            File(
              controller.filePathString.value,
            ),
          )
              : controller.userModel.imageUrl == ''
                ? const AssetImage(Assets.menCartoon)
                : NetworkImage(
                    controller.userModel.imageUrl,
                  )
          as ImageProvider,
        ),
      ),
    );
  }


  Future<File?> pickImageFromGallery(BuildContext context) async {
    File? image;
    try {
      debugPrint('Start');

      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);

        controller.imageSelected.value = true;
        controller.file = image;
        controller.filePathString.value = image.path;
        debugPrint('Selected');

        ToastMessage.success('Image Selected');
      }

    } catch (e) {
      debugPrint(e.toString());
      ToastMessage.error(e.toString());
    }
    return image;
  }

}
