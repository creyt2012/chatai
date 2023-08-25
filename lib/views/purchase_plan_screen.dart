// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:get/get.dart';


import '../helper/local_storage.dart';

import '../controller/plan_controller.dart';
import '../routes/routes.dart';
import '../services/ssl_commerz.dart';
import '../services/stripe_service.dart';
import '../utils/custom_color.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../widgets/appbar/appbar_widget2.dart';

import 'payment_method/paypal_payment.dart';

class PurchasePlanScreen extends StatelessWidget {
  PurchasePlanScreen({Key? key}) : super(key: key);



  final controller = Get.put(PlanController());
  var paymentController = StripeService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget2(
        context: context,
        appTitle: Strings.subscriptionPlan.tr,
        onTap: () {
          Get.toNamed(Routes.homeScreen);
        },
      ),
      body: _bodyWidget(context),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.symmetric(
      //     vertical: Dimensions.heightSize,
      //     horizontal: Dimensions.widthSize,
      //   ),
      //
      //   child: TextButton(
      //     onPressed: perfomMagic,
      //     child: const Text('App Purchase'),
      //   ),
      // ),
    );
  }

  _bodyWidget(BuildContext context) {
    return GetBuilder(
      builder: (PlanController controller) {
        return Column(
          children: [
            _purchaseWidget(
              onTap: () {
                // controller.updateUserPlan();
                Get.toNamed(Routes.homeScreen);

              },
              color: CustomColor.secondaryColor,
              title: Strings.freeSubscription.tr,
              price: '0.00',
              support: Strings.notIncluded.tr,
              firstService: Strings.limitedChatting.tr,
              secondService: '',
            ),
            _purchaseWidget(
              onTap: () {
                _showDialog(context);
              },
              color: CustomColor.secondaryColor2,
              title: Strings.premiumSubscription.tr,
              price: '9.00',
              visible: true,
              support: '24/7',
              firstService: Strings.unlimitedChatting.tr,
              secondService: Strings.unlimitedImage.tr,
            ),
          ],
        );
      },
    );
  }

  _purchaseWidget({
    required VoidCallback onTap,
    required Color color,
    required String title,
    required String price,
    required String support,
    required String firstService,
    required String secondService,
    bool visible = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.widthSize * 2,
            vertical: Dimensions.heightSize),
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.widthSize * 2,
            vertical: Dimensions.heightSize * 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimensions.radius * 3),
              bottomLeft: Radius.circular(Dimensions.radius * 3),
            ),
            color: color.withOpacity(Get.isDarkMode ? 0.03 : 1),
            border: Border.all(
                width: 2, color: color.withOpacity(Get.isDarkMode ? 0.08 : 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: CustomStyle.primaryTextStyle.copyWith(
                  fontSize: Dimensions.defaultTextSize * 2,
                  color: Get.isDarkMode ? color : Colors.white),
            ),
            SizedBox(
              height: Dimensions.heightSize,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\$ $price",
                  style: CustomStyle.primaryTextStyle.copyWith(
                      fontSize: Dimensions.defaultTextSize * 4,
                      color: Get.isDarkMode ? color : Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                Visibility(
                  visible: visible,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Dimensions.widthSize * .5,
                      ),
                      Container(
                        height: Dimensions.heightSize * 2,
                        width: 2,
                        color: Get.isDarkMode ? color : Colors.white,
                      ),
                      SizedBox(
                        width: Dimensions.widthSize * .5,
                      ),
                      Text(
                        Strings.perMonth.tr,
                        style: CustomStyle.primaryTextStyle.copyWith(
                          fontSize: Dimensions.defaultTextSize * 1.4,
                          color: Get.isDarkMode ? color : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.heightSize * .5,
            ),
            Text(
              '${Strings.freeSupport.tr} $support',
              style: CustomStyle.primaryTextStyle.copyWith(
                  fontSize: Dimensions.defaultTextSize * 1.2,
                  color: Get.isDarkMode
                      ? color.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Dimensions.heightSize * 1,
            ),
            Text(
              "• $firstService",
              style: CustomStyle.primaryTextStyle.copyWith(
                  fontSize: Dimensions.defaultTextSize * 1.4,
                  color: Get.isDarkMode ? color : Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Dimensions.heightSize * .5,
            ),
            Text(
              "• $secondService",
              style: CustomStyle.primaryTextStyle.copyWith(
                  fontSize: Dimensions.defaultTextSize * 1.4,
                  color: Get.isDarkMode ? color : Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.widthSize * 3,
                vertical: Dimensions.heightSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  controller.paymentMethod.length,
                      (index) => Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthSize * 1,
                        vertical: Dimensions.heightSize * 0.5),
                    child: TextButton(
                        onPressed: (){
                          controller.selectedMethod.value = controller.paymentMethod[index];
                          paymentPressedFunction(index, context);
                        },
                        child: Row(
                          children: [
                            Image.asset(
                                controller.paymentMethodIcon[index],
                              scale: index == 2 ? 14 : 3
                            ),
                            SizedBox(
                              width: Dimensions.widthSize,
                            ),
                            Text(
                              controller.paymentMethod[index],
                              style: const TextStyle(
                                  color: CustomColor.blackColor),
                            ),
                          ],
                        )),
                  )),
            ),
          );
        });
  }

  void paymentPressedFunction(int index, BuildContext context) async{
    if (index == 0) {
      debugPrint("WORKED PAYPAL");
      Get.back();
      debugPrint("WORKED PAYPAL");
      if(LocalStorage.getPaypalStatus()){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PaypalPayment(
              onFinish: (number) async {
                controller.updateUserPlan();
              },
            ),
          ),
        );
      }else{
        Get.snackbar("Alert!", 'Paypal is not active.');
      }
    }
    else if (index == 1) {
      if(LocalStorage.getStripeStatus()){
        paymentController.makePayment(amount: '9', currency: 'USD');
        Get.back();
      }else{
        Get.snackbar("Alert!", 'Stripe is not active.');
      }
    }
    else if(index == 2){
      var result = await EasySSLCommerz(
          amount: 100.00,
          productCategory: '',
          customerAddress1: '',
          customerCity: '',
          customerCountry: '',
          customerEmail: '',
          customerName: '',
          customerPhone: '',
          customerPostCode: '',
          customerState: ''
      ).payNow();

      if (result is PlatformException) {
        debugPrint("the response is: ${result.message.toString()} code: ${result.code}");
      }
      else {
        SSLCTransactionInfoModel model = result as SSLCTransactionInfoModel;
        debugPrint("SSLCTransactionInfoModel: ${model.toJson().toString()}");
      }
    }
  }
}
