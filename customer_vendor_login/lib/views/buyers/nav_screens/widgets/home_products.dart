import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebooked_app/views/buyers/productDetail/product_detail_screen.dart';

class HomeProducts extends StatelessWidget {
  final String categoryName;

  const HomeProducts({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryName).where('approved', isEqualTo: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LinearProgressIndicator(
              color: Colors.yellow.shade800,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Container(
            height: 260,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  return Container(
                    width: 170,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.3),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            2.0, // Move to right 10  horizontally
                            2.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context){
                            return ProductDetailScreen(productData: productData);
                          })
                        );
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
                                  image: NetworkImage(
                                      productData['imageUrlList'][0]),
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
                    ),
                  );
                },
                separatorBuilder: (context, _) => SizedBox(
                      width: 15,
                    ),
                itemCount: snapshot.data!.docs.length),
          ),
        );
      },
    );
  }
}
