import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:rebooked_app/provider/cart_provider.dart';
import 'package:rebooked_app/views/buyers/inner_screens.dart/edit_profile_screen.dart';
import 'package:rebooked_app/views/buyers/main_screen.dart';
import 'package:uuid/uuid.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.yellow.shade800,
              title: Text(
                "CHECK-OUT",
                style: TextStyle(
                  letterSpacing: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: _cartProvider.getCartItem.length,
              itemBuilder: (context, index) {
                final cartData =
                    _cartProvider.getCartItem.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                  child: Card(
                    elevation: 4,
                    color: Color.fromARGB(255, 244, 244, 244),
                    child: SizedBox(
                      height: 150,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(cartData.imageUrlList[0]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 240,
                                  child: Text(
                                    cartData.productName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "₹ " +
                                      cartData.productPrice.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow.shade800,
                                    letterSpacing: 5,
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: null,
                                  child: Text(
                                    cartData.yearList,
                                    style: TextStyle(
                                      color: Colors.yellow.shade800,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(7, 23),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            bottomSheet: data['address'] == "" ? TextButton(
              onPressed: (){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context){
                    return EditProfileScreen(userData: data);
                  })
                ).whenComplete(() {
                  Navigator.pop(context);
                });
              }, 
              child: Text("Enter Billing Address"),
              ) : Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  EasyLoading.show(status: "Placing Order");
                  _cartProvider.getCartItem.forEach((key, item) {
                    final orderId = Uuid().v4();
                    _firestore.collection('orders').doc(orderId).set({
                      'orderId': orderId,
                      'vendorId': item.vendorId,
                      'email': data['email'],
                      'phone': data['phoneNum'],
                      'address': data['address'],
                      'buyerId': data['buyerId'],
                      'fullName': data['fullName'],
                      'buyerPhoto': data['profileImage'],
                      'productName': item.productName,
                      'productPrice': item.productPrice,
                      'productId': item.productId,
                      'productImage': item.imageUrlList,
                      'quantity': item.quantity,
                      'productSize': item.yearList,
                      'scheduleDate': item.scheduleDate,
                      'orderDate': DateTime.now(),
                      'accepted': true,
                    }).whenComplete(() {
                      setState(() {
                        _cartProvider.getCartItem.clear();
                      });
                      EasyLoading.dismiss();

                      Navigator.pushReplacement(context, 
                        MaterialPageRoute(builder: (context){
                          return MainScreen();
                        })
                      );
                    });

                  });
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "PLACE ORDER",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 7,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator(color: Colors.yellow.shade800,),);
      },
    );
  }
}
