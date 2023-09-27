import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:rebooked_app/provider/product_provider.dart';
import 'package:rebooked_app/vendor/views/screens/main_vendor_screen.dart';
import 'package:rebooked_app/vendor/views/screens/upload_tap_screen/attributes_tab_screen.dart';
import 'package:rebooked_app/vendor/views/screens/upload_tap_screen/general_screen.dart';
import 'package:rebooked_app/vendor/views/screens/upload_tap_screen/images_tab_screen.dart';
import 'package:rebooked_app/vendor/views/screens/upload_tap_screen/shipping_screen.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 4, 
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.yellow.shade800,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("General"),
                ),
                Tab(
                  child: Text("Shipping"),
                ),
                Tab(
                  child: Text("Attributes"),
                ),
                Tab(
                  child: Text("Image"),
                ),
              ]
            ),
          ),
          body: TabBarView(
            children: [
              GeneralScreen(),
              ShippingScreen(),
              AttributeTabScreen(),
              ImagesTabScreen(),
            ]
          ),
          
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            
            child: ElevatedButton( 
                  style: ElevatedButton.styleFrom(
                      primary: Colors.yellow.shade800,
                  ), 
                  onPressed: () async{
                    EasyLoading.show(status: "Please wait");
                    if(_formKey.currentState!.validate()){
                      print("Started");
                      final productId = Uuid().v4();
                      await _firestore.collection('products').doc(productId).set({
                        'productId': productId,
                        'productName': _productProvider.productData['productName'],
                        'productPrice': _productProvider.productData['productPrice'],
                        'quantity': _productProvider.productData['quantity'],
                        'category': _productProvider.productData['category'],
                        'description': _productProvider.productData['description'],
                        'schedule': _productProvider.productData['schedule'],
                        'imageUrlList': _productProvider.productData['imageUrlList'],
                        'chargeShipping': _productProvider.productData['chargeShipping'],
                        'shippingCharge': _productProvider.productData['shippingCharge'],
                        'publisherName': _productProvider.productData['publisherName'],
                        'yearList': _productProvider.productData['yearList'],
                        'vendorId': FirebaseAuth.instance.currentUser!.uid,
                        'approved': false,
                      }).whenComplete(() {
                        print("Stage1");
                        _productProvider.clearData();
                        _formKey.currentState!.reset();
                        print("Stage2");
                        EasyLoading.dismiss();
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context){
                          return MainVendorScreen();
                        }));
                        print("done");
                      });
                    }else{
                      EasyLoading.dismiss();
                    }
                  },
                  child: Text("Save"),
                ),
          ),
        ),
      ),
    );
  }
}