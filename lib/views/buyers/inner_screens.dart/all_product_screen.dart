import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebooked_app/views/buyers/productDetail/product_detail_screen.dart';

class AllProductScreen extends StatelessWidget {
  final dynamic categoryData;

  const AllProductScreen({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryData['categoryName']).where('approved', isEqualTo: true)
        .snapshots();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 220, 220),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.yellow.shade800,
        title: Text(
          categoryData['categoryName'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 6,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: Colors.yellow.shade800,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: snapshot.data!.size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 200 / 300,
              ),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ProductDetailScreen(productData: productData);
                    }));
                  },
                  child: Card(
                    color: Color.fromARGB(255, 244, 244, 244),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 130,
                          width: 170,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(productData['imageUrlList'][0]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              productData['productName'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "₹ " + productData['productPrice'].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                                color: Colors.yellow.shade800,
                              ),
                            ),
                          ),
                        )
                      ],
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
