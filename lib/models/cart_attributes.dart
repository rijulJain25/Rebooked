import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CartAttr with ChangeNotifier {
  final String productName;
  final String productId;
  final List imageUrlList;
  int quantity;
  int productQuantity;
  final double productPrice;
  final String vendorId;
  final String yearList;
  final Timestamp scheduleDate;

  CartAttr({
      required this.productName,
      required this.productId,
      required this.imageUrlList,
      required this.quantity,
      required this.productQuantity,
      required this.productPrice,
      required this.vendorId,
      required this.yearList,
      required this.scheduleDate,
    });

    void increase(){
      quantity++;
    }

    void decrease(){
      quantity--;
    }
}
