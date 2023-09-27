import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebooked_app/views/buyers/productDetail/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchedValue = '';

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance.collection('products').snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        title: TextFormField(
          onChanged:(value) {
            setState(() {
              _searchedValue = value;
            });
          },
          decoration: InputDecoration(
            labelText: "Search for Products",
            labelStyle: TextStyle(
              letterSpacing: 4,
              color: Colors.white,
              fontSize: 18,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
              ),
          ),

        ),
        
      ),

      body: _searchedValue == '' ? Center(
        child: Text(
          "Search for Products",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 2,
          ),
        ),
      ) : StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        final searchedData = snapshot.data!.docs.where((element) {
          return element['productName'].toLowerCase().contains(_searchedValue.toLowerCase());
        });

        return SingleChildScrollView(
          child: Column(
            children: 
              searchedData.map((e) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context){
                        return ProductDetailScreen(productData: e);
                      })
                    );
                  },
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(e['imageUrlList'][0]),
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e['productName'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        
                            Text(
                              '₹'+e['productPrice'].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                        
                      ],
                    ),
                  ),
                );
              }).toList(),
          ),
        );
      }
    ),

    );
  }
}