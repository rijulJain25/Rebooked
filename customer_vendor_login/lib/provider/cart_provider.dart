import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:rebooked_app/models/cart_attributes.dart';

class CartProvider with ChangeNotifier{
  Map<String, CartAttr> _cartItems = {}; 

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  double totalPrice(){
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.productPrice * value.quantity;
    });
    return total;
  }

  void addProductToCart(
    String productName,
    String productId,
    List imageUrlList,
    int quantity,
    int productQuantity,
    double productPrice,
    String vendorId,
    String yearList,
    Timestamp scheduleDate,
  ){
    if(_cartItems.containsKey(productId)){
      _cartItems.update(productId, (exitingCart) =>
        CartAttr(
          productName: exitingCart.productName,
          productId: exitingCart.productId,
          imageUrlList: exitingCart.imageUrlList,
          quantity: exitingCart.quantity+1,
          productQuantity: exitingCart.productQuantity,
          productPrice: exitingCart.productPrice,
          vendorId: exitingCart.vendorId,
          yearList: exitingCart.yearList,
          scheduleDate: exitingCart.scheduleDate,
        )
      );
      notifyListeners();
    }else{
      _cartItems.putIfAbsent(productId, () => CartAttr(
        productName: productName, 
        productId: productId, 
        imageUrlList: imageUrlList, 
        quantity: quantity, 
        productQuantity: productQuantity,
        productPrice: productPrice, 
        vendorId: vendorId, 
        yearList: yearList, 
        scheduleDate: scheduleDate));
        notifyListeners();
    }
  }

  void increment(CartAttr cartAttr){
    cartAttr.increase();
    notifyListeners();
  }

  void decrement(CartAttr cartAttr){
    cartAttr.decrease();
    notifyListeners();
  }

  removeItem(productId){
    _cartItems.remove(productId);
    notifyListeners();
  }

  removeAllItem(){
    _cartItems.clear();
    notifyListeners();
  }
}

