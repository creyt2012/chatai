import 'dart:math';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';

class EasySSLCommerz{
  double amount;
  String customerName;
  String customerEmail;
  String customerPhone;
  String customerCountry;
  String customerPostCode;
  String customerCity;
  String customerAddress1;
  String productCategory;
  String customerState;

  late Sslcommerz _sslcommerz;


  EasySSLCommerz({
    required this.amount,
    required this.productCategory,
    required this.customerEmail,
    required this.customerName,
    required this.customerPhone,
    required this.customerCountry,
    required this.customerPostCode,
    required this.customerAddress1,
    required this.customerCity,
    required this.customerState,
  }){
    config();
  }
  void config(){
    _sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
            currency: SSLCurrencyType.BDT,
            product_category: "Any",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: "appde6406d3d788fb1",
            store_passwd: "appde6406d3d788fb1@ssl",
            total_amount: amount,
            tran_id: getRandomString(16)));

    _sslcommerz.customerInfoInitializer = SSLCCustomerInfoInitializer(
        customerName: '',
        customerEmail: customerEmail,
        customerAddress1: customerAddress1,
        customerCity: customerCity,
        customerPostCode: customerPostCode,
        customerCountry: customerCountry,
        customerPhone: customerPhone,
        customerState: customerState
    );

  }

  Future<dynamic>  payNow() async{
    return await _sslcommerz.payNow();
  }

  String getRandomString(int length){
    Random rnd = Random();
    String chars = '0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
