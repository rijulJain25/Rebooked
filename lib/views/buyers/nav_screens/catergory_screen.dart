import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebooked_app/views/buyers/inner_screens.dart/all_product_screen.dart';

class CatergoryScreen extends StatelessWidget {
  const CatergoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('categories').snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.yellow.shade800,
        title: Text(
          'CATEGORIES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 7,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.yellow.shade800,);
        }

        return Container(
          height: 800,
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder:(context, index) {
              final categoryData = snapshot.data!.docs[index];
              return Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 235, 235, 235),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: ListTile(   
                  onTap: () {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context){
                        return AllProductScreen(categoryData: categoryData);
                      })
                    );
                  },
                               
                  leading: Image.network(categoryData['image']),
                  title: Text(
                    categoryData['categoryName'],
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
    );
  }
}