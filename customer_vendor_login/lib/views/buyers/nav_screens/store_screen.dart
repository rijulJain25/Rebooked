import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebooked_app/views/buyers/productDetail/store_detail_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorsStream =
        FirebaseFirestore.instance.collection('vendors').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _vendorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.yellow.shade800),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'NO VENDORS AVAILABLE',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow.shade800,
            title: Text(
              "ALL OUR VENDORS",
              style: TextStyle(
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(15),
            height: 500,
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final storeData = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StoreDetailScreen(storeData: storeData);
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 235, 235, 235),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: ListTile(
                        title: Text(
                          storeData['businessName'],
                        ),
                        subtitle: Text(
                          storeData['countryValue'],
                        ),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(storeData['storeImage']),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
