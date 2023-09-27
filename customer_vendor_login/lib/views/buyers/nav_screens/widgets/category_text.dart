import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebooked_app/views/buyers/nav_screens/catergory_screen.dart';
import 'package:rebooked_app/views/buyers/nav_screens/widgets/home_products.dart';
import 'package:rebooked_app/views/buyers/nav_screens/widgets/main_product_widget.dart';

class CategoryText extends StatefulWidget {
  @override
  State<CategoryText> createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  // final List<String> _categoryLabel = ['CBSE', 'ICSE', 'Fiction', 'Poetic', 'Novels', 'Historic', 'BioGraphy'];
  String? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 19,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _categoryStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Loading categories"),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Container(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final categoryData = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ActionChip(
                                  backgroundColor: Colors.yellow[800],
                                  onPressed: () {
                                    setState(() {
                                      _selectedCategory =
                                        categoryData['categoryName'];
                                    }); 
                                  },
                                  label: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text(
                                      categoryData['categoryName'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return CatergoryScreen();
                          }));
                        }, 
                        icon: Icon(Icons.arrow_forward_ios)
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if(_selectedCategory == null)
            MainProductWidget(),
          
          if(_selectedCategory != null)
            HomeProducts(categoryName: _selectedCategory!),
          
        ],
      ),
    );
  }
}
