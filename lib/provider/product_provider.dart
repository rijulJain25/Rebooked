
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  Map<String, dynamic> productData = {};

  ProductProvider() {
    productData = {};
  }

  getFormData({
    String? productName, 
    double? productPrice, 
    int? quantity, 
    String? category, 
    String? description, 
    DateTime? schedule,
    List<String>? imageUrlList,
    bool? chargeShipping,
    int? shippingCharge,
    String? publisherName,
    List<String>? yearList,
  }){
    if(productName != null){
      productData['productName'] = productName;
    }

    if(productPrice != null){
      productData['productPrice'] = productPrice;
    }

    if(quantity != null){
      productData['quantity'] = quantity;
    }

    if(category != null){
      productData['category'] = category;
    }

    if(description != null){
      productData['description'] = description;
    }

    if(schedule != null){
      productData['schedule'] = schedule;
    }

    if(imageUrlList != null){
      productData['imageUrlList'] = imageUrlList;
    }

    if(chargeShipping != null){
      productData['chargeShipping'] = chargeShipping;
    }

    if(shippingCharge != null){
      productData['shippingCharge'] = shippingCharge;
    }

    if(publisherName != null){
      productData['publisherName'] = publisherName;
    }

    if(yearList != null){
      productData['yearList'] = yearList;
    }

    notifyListeners();
  } 
  clearData(){
      productData.clear();
      notifyListeners();
    }
}