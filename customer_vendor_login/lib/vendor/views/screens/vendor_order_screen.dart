import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class VendorOrderScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formatedDate(date) {
    final outputDateFormate = DateFormat('dd/MM/yyyy');
    final outputDate = outputDateFormate.format(date);
    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
        title: Text(
          "MY ORDERS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 5,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade800,
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Slidable(
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          child: document['accepted'] == true
                              ? Icon(Icons.delivery_dining)
                              : Icon(Icons.access_time),
                        ),
                        title: document['accepted'] == true
                            ? Text(
                                "Accepted",
                                style: TextStyle(
                                  color: Colors.yellow.shade800,
                                ),
                              )
                            : Text(
                                "Not Accepted",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                        trailing: Text(
                          'Amount ' + document['productPrice'].toString(),
                          style: TextStyle(fontSize: 17, color: Colors.blue),
                        ),
                        subtitle: Text(
                          formatedDate(
                            document['orderDate'].toDate(),
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      ExpansionTile(
                        title: Text(
                          "Order Details",
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          "View Order List",
                        ),
                        children: [
                          ListTile(
                            leading: ClipRRect(
                              child: Image.network(document['productImage'][0]),
                            ),
                            title: Text(
                              document['productName'],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      ('Quantity: '),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      document['quantity'].toString(),
                                    ),
                                  ],
                                ),
                                document['accepted'] == true
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Schedule Delivery Date: "),
                                          Text(formatedDate(
                                              document['scheduleDate']
                                                  .toDate())),
                                        ],
                                      )
                                    : Text(""),
                                ListTile(
                                  title: Text(
                                    'Buyers Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document['fullName'],
                                      ),
                                      Text(
                                        document['email'],
                                      ),
                                      Text(
                                        document['address'],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          await _firestore
                              .collection('orders')
                              .doc(document['orderId'])
                              .update({
                            'accepted': true,
                          });
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.add_circle_outline_sharp,
                        label: 'Accept',
                      ),
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          await _firestore
                              .collection('orders')
                              .doc(document['orderId'])
                              .update({
                            'accepted': false,
                          });
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.remove_circle_outline,
                        label: 'Reject',
                      ),
                    ],
                  ));
            }).toList(),
          );
        },
      ),
    );
  }
}
