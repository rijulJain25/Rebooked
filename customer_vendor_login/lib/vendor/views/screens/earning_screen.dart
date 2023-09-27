import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rebooked_app/vendor/views/screens/vendor_inner_screen/withdrawal_screen.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('vendors');
    final Stream<QuerySnapshot> _ordersStream =
        FirebaseFirestore.instance.collection('orders').where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
                   
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
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['storeImage']),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Welcome Back ' + data['businessName'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: _ordersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  double totalOrder = 0.0;
                  for(var orderItem in snapshot.data!.docs){
                    totalOrder += orderItem['quantity']*orderItem['productPrice'];
                  }

                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade800,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "TOTAL EARNINGS",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "₹"+totalOrder.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),

                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade800,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "TOTAL ORDERS",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),

                          InkWell(
                            onTap:() {
                              Navigator.push(context, 
                                MaterialPageRoute(builder: ((context) {
                                  return WithDrawalScreen();
                                }))
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width-50,
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade800,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 45,
                              child: Center(
                                child: Text(
                                  "WITHDRAW EARNINGS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    letterSpacing: 3
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  );
                },
              ));
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade800,
          ),
        );
      },
    );
  }
}
