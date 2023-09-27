import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VendorWidget extends StatelessWidget {
  const VendorWidget({super.key});

  Widget VendorData(int? flex, Widget widget) {
    return Expanded(
        flex: flex!,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorsStream =
        FirebaseFirestore.instance.collection('vendors').snapshots();

    final FirebaseFirestore _firestore = FirebaseFirestore.instance; 
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final VendorUserData = snapshot.data!.docs[index];
            return Container(
              child: Row(
                children: [
                  VendorData(
                      1,
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.network(VendorUserData['storeImage']),
                      )),
                  VendorData(
                      3,
                      Text(
                        VendorUserData['businessName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  VendorData(
                      2,
                      Text(
                        VendorUserData['stateValue'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  VendorData(
                      2,
                      Text(
                        VendorUserData['cityValue'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  VendorData(
                    1,
                    VendorUserData['approved'] == false ? 
                    ElevatedButton(
                      onPressed: () async{
                        await _firestore
                        .collection('vendors')
                        .doc(VendorUserData['vendorId'])
                        .update({
                          'approved': true,
                        });
                      },
                      child: Text("Approve"),
                    ): ElevatedButton(
                      onPressed: () async{
                        await _firestore
                        .collection('vendors')
                        .doc(VendorUserData['vendorId'])
                        .update({
                          'approved': false,
                        });
                      },
                      child: Text("Reject"),
                    ),
                  ),
                  VendorData(
                    1,
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("View More"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
